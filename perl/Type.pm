package Type;
use 5.10.0;
use strict;
use warnings;

sub new {
	my $class = shift;
	my %args = @_;
	$class = ref $class if ref $class;
	
	my $self = {
		name => ($args{name} || undef),
		dbtype => ($args{dbtype} || undef), #native type
		dbtraits => ($args{dbtraits} || []),
		min => ($args{min} || undef),
		max => ($args{max} || undef),
		match => ($args{match} || undef),
		default => ($args{default} || undef),
		class => ($args{class} || ''),
		label => ($args{label} || undef),
		optional => ($args{optional} || 0),
	};
	
	bless $self, $class;
}

sub copy {
	my ($self, $other) = @_;

	$self->{name} = $other->{name} if defined $other->{name};
	$self->{dbtype} = $other->{dbtype}  if defined $other->{dbtype};
	$self->{dbtraits} = $other->{dbtraits}  if defined $other->{dbtraits};
	$self->{min} = $other->{min}  if defined $other->{min};
	$self->{max} = $other->{max}  if defined $other->{max};
	$self->{match} = $other->{match}  if defined $other->{match};
	$self->{default} = $other->{default}  if defined $other->{default};
	$self->{label} = $other->{label}  if defined $other->{label};
	
}

sub addTraits {
	my ($self, @traits) = @_;
	
	push @{$self->{dbtraits}}, @traits
}

sub setName {
	my ($self, $n) = @_;
	
	$self->{name} = $n;
}

sub setDefault {
	my ($self, $d) = @_;
	
	$self->{default} = $d;
}

sub setLabel {
	my ($self, $l) = @_;
	
	$self->{label} = $l;
}

sub setType {
	my ($self, $t) = @_;
	
	$self->{dbtype} = $t;
	if (!defined $self->{default}) {
		if ($t =~ /int|bool/) {
			$self->setDefault(0);
		}
		elsif ($t =~ /string|password_t|email_t/) {
			$self->setDefault('');
		}
		elsif ($t =~ /float|double/) {
			$self->setDefault('0.0');
		}
	} 
}	

sub setOpt {
	my ($self, $t) = @_;
	
	$self->{optional} = $t || 0;
}

sub setMin {
	my $self = shift;
	my $m = shift;
	
	$self->{min} = $m;
	
	if ($self->{name} eq 'uint') {
		#error
	}
}

sub setMax {
	my $self = shift;
	my $m = shift;
	
	$self->{max} = $m;
}

sub setMatch { 
	my ($self, $m) = @_;
	
	$self->{match} = $m;
}

sub printDBCreate {
	my $self = shift;
	
	my $str = "`$self->{name}` ";
	given ($self->{dbtype}) {
		when (/int|bool/) {
			$str .= $self->getInt;
			$str .= $self->getTraits;
			unless ($str =~ /auto_increment/i and defined $self->{default}) {
				$str .= ' NOT NULL DEFAULT ' . $self->{default} . ' '
			}
		}
		when (/string|password_t|email_t/) {
			$str .= $self->getString;
			unless ($str =~ /auto_increment/i and defined $self->{default}) {
				$str .= ' NOT NULL DEFAULT "' . $self->{default} . '" ' 
			}
		}
		when (/float|double/) {
			$str .= $self->getFloat;
			unless ( defined $self->{default}) {
				$str .= ' NOT NULL DEFAULT '. $self->{default} . ' '
			}
		}
	}
	

	return "$str,\n";
}

sub printDefString {
	my $self = shift;

	if ($self->{dbtype} =~ /int|bool/) {
		return $self->{default} || 0
	}
	elsif ($self->{dbtype} =~ /string|password_t|email_t/) {
		return '"' . ($self->{default} || '') . '"'
	}
	elsif ($self->{dbtype} =~ /float|double/) {
		return $self->{default} || '0.0'
	}

}

sub dbArgName {
	my $self = shift;
	return 'a_' . $self->{name};
}

sub dbClassName {
	my $self = shift;

	return "$self->{class}.$self->{name}" if $self->{class};
	return $self->{name}
}

sub printDBArg {
	my $self = shift;
	
	my $str = $self->dbArgName;
	given ($self->{dbtype}) {
		when (/int|bool/) {
			$str .= $self->getInt;
		}
		when (/string|password_t|email_t/) {
			$str .= $self->getString;
		}
		when (/float|double/) {
			$str .= $self->getFloat
		}
	}

	return $str;
}

sub getTraits {
	my $self = shift;
	
	return join(' ', @{$self->{dbtraits}}); 
}

sub getInt {
	my $self = shift;
	
	if ($self->{dbtype} =~ /^bool/) {
		return ' TINYINT UNSIGNED ';
	}
	
	if ($self->{dbtype} =~ /^int/) {
		if (!$self->{max}) {
			return ' INT '
		}
		if ($self->{max} <= 127) {
			return ' TINYINT ';
		}
		elsif ($self->{max} <= 32767) {
			return ' SMALLINT ';
		}
		elsif ($self->{max} <= 2147483647) {
			return ' INT ';
		}
		else {
			return ' BIGINT ';
		}
	} else {
		if (!$self->{max}) {
			return ' INT UNSIGNED '
		}
		if ($self->{max} <= 255) {
			return ' TINYINT UNSIGNED ';
		}
		elsif ($self->{max} <= 65535) {
			return ' SMALLINT UNSIGNED ';
		}
		elsif ($self->{max} <= 4294967295) {
			return ' INT UNSIGNED ';
		}
		else {
			return ' BIGINT UNSIGNED ';
		}
	}
}

sub getFloat {
	my $self = shift;
	
	if ($self->{dbtype} =~ /float|double/) {
		return ' FLOAT ';
	}
}

sub getString {
	my $self = shift;
	
	given ($self->{dbtype}) {
		when (/string/) {
			if (!defined $self->{max} or $self->{max} > 2048) {
				return ' TEXT ';
			}
			else {
				return ' VARCHAR(' . $self->{max} . ') ';
			}
		}
		when (/password_t/) {
			return ' VARCHAR(32) '
		}
		when (/email_t/) {
			return ' VARCHAR(100) '
		}
	}
}

sub phpFilter {
	my $self = shift;
	
	my $rv = '';
	
	given ($self->{dbtype}) {
		when (/string/) {
			if (defined $self->{match}) {
				$rv = "array('filter' => FILTER_VALIDATE_REGEXP, 'options' => array('regexp' => \"$self->{match}\"))"
			}
			elsif (defined $self->{max} and defined $self->{min}) {
				$rv = "array('filter' => FILTER_VALIDATE_REGEXP, 'options' => array('regexp' => \"^.{$self->{min},$self->{max}}\$\"))"
			}
			else {
				$rv = 'FILTER_SANITIZE_STRING'
			}
		}
		when (/password/) {
			$rv = 'FILTER_UNSAFE_RAW'
		}
		when (/email/) {
			$rv = 'FILTER_VALIDATE_EMAIL'
		}
		when (/double|float/) {
			$rv = 'FILTER_VALIDATE_FLOAT'
		}
		when (/bool/) {
			$rv = 'FILTER_VALIDATE_BOOLEAN'
		}
		when (/int|uint/) {
			if (defined $self->{max} and defined $self->{min}) {
				$rv = "array('filter' => FILTER_VALIDATE_INT, 'options' => array('min_range' => $self->{min}, 'max_range' => $self->{max}))"
			}
			else {
				$rv = 'FILTER_VALIDATE_INT'
			}
		}
	}
	
	return $rv

}

sub kwToDb {
	my $self = shift;
	
	my %conv = (
		'bool' => 'tinyint unsigned',
		'int' => 'int',
		'uint' => 'int unsigned',
		'string' => 'varchar',
		'email_t' => 'varchar',
		'password_t' => 'varchar',
		'float' => 'float',
		'double' => 'float',
	);
	
	return $conv{$self->{dbtype}} || ''
	
}

1;
__END__
