package Class;
use 5.10.0;
use strict;
use warnings;
use Type;

sub new {
	my $class = shift;
	my %args = @_;
	
	
	my $self = {
		name => $args{name},
		members => [],
		indexes => [],
		pk => [],
		userpk => {},
		dbfn => []
	};
	
	bless $self, $class;
}

sub getNonePKMembers {
	my $self = shift;
	my @members = ();
	for my $arg (@{$self->{members}}) {
		unless ($self->isPK($arg->{name}, 1)) {
			push @members, $arg;
		}
	}
	return @members
	
}

sub printDBCreate {
	my $self = shift;
	my $str = "DROP TABLE IF EXISTS #db#.`$self->{name}`//\n";
	$str .= "CREATE TABLE #db#.`$self->{name}` (\n";
	for my $m (@{$self->{members}}) {
		$str .= "\t" . $m->printDBCreate;
	}
	$str .= $self->indexes;
	$str .= ") Engine=InnoDb;//\n";
	
	return $str;
}

sub indexes {
	my $self = shift;
	my @indexes = ();
	
	for my $idx (@{$self->{indexes}}) {
		push @indexes, "\tINDEX (" . join(', ', @{$idx}) . ")"
	}
	
	if (scalar @{$self->{pk}}) {
		push @indexes, "\tPRIMARY KEY (" . join(', ', @{$self->{pk}}) . ")"
	}
	
	
	return join(",\n", @indexes) . "\n";
}

sub addDbFunction {
	my $self = shift;
	my @fn = @_;
	push @{$self->{dbfn}}, @fn
}

sub addIndex {
	my $self = shift;
	my @indexes = @_;
	push @{$self->{indexes}}, [@indexes];
}

sub addPk {
	my $self = shift;
	my @PK = @_;
	$self->{pk} = [@PK];
}

sub addUserPk {
	my $self = shift;
	my @PK = @_;
	$self->{pk} = [@PK];
	$self->{userpk} = {map { $_ => 1} @PK};
}

sub addMember {
	my ($self, $member) = @_;
	$member->{class} = $self->{name};
	push @{$self->{members}}, $member;
}

sub getArg {
	my ($self, $argName) = @_;
	for my $arg (@{$self->{members}}) {
		if ($arg->{name} eq $argName) {
			return $arg
		}
	}
}

sub printArg {
	my ($self, $argName) = @_;
	for my $arg (@{$self->{members}}) {
		if ($arg->{name} eq $argName) {
			return $arg->printDBArg
		}
	}
}

sub printCRUD {
	my $self = shift;
	
	return $self->create . $self->read . $self->update . $self->delete;
}

sub create {
	my $self = shift;
	my $str = "DROP PROCEDURE IF EXISTS #db#.create$self->{name}//\n";
	$str .= "CREATE PROCEDURE #db#.create$self->{name} (\n";
	my @args = ();
	for my $arg (@{$self->{members}}) {
		unless ($self->isPK($arg->{name}, 1)) {
			push @args, "\t" . $arg->printDBArg;
		}
	}
	$str .= join(",\n", @args);
	$str .= "\n) BEGIN\n";
	
	$str .= "\tINSERT INTO #db#.$self->{name} SET\n";
	my @set = ();
	for my $arg (@{$self->{members}}) {
		unless ($self->isPK($arg->{name}, 1)) {
			push @set, "\t\t`$arg->{name}` = " . $arg->dbArgName
		}
	}
	$str .= join(",\n", @set);
	$str .= ";\n";
	$str .= "\tSELECT last_insert_id() as retCode;\n";
	
	$str .= "\nEND;//\n\n";
	return $str;
}

sub read {
	my $self = shift;
	my $str = "DROP PROCEDURE IF EXISTS #db#.get$self->{name}//\n";
	$str .= "CREATE PROCEDURE #db#.get$self->{name} (\n";
	my @args = ();
	for my $arg (@{$self->{members}}) {
		if ($self->isPK($arg->{name})) {
			push @args, "\t" . $arg->printDBArg;
		}
	}
	$str .= join(",\n", @args);
	$str .= "\n) BEGIN\n";
	
	$str .= "\tSELECT * FROM #db#.$self->{name} ";	
	$str .= "\n\tWHERE\n";
	
	my @where = ();
	for my $arg (@{$self->{members}}) {
		if ($self->isPK($arg->{name})) {
			push @where, "\t\t" . $arg->dbClassName . ' = ' . $arg->dbArgName
		}
	}
	$str .= join(" AND\n", @where) . ";\n";
	
	$str .= "\nEND;//\n\n";
	return $str;
}

sub update {
	my $self = shift;
	my $str = "DROP PROCEDURE IF EXISTS #db#.update$self->{name}//\n";
	$str .= "CREATE PROCEDURE #db#.update$self->{name} (\n";
	my @args = ();
	for my $arg (@{$self->{members}}) {
		push @args, "\t" . $arg->printDBArg;

	}
	$str .= join(",\n", @args);
	$str .= "\n) BEGIN\n";
	
	$str .= "\tUPDATE #db#.$self->{name} SET\n";
	my @set = ();
	for my $arg (@{$self->{members}}) {
		unless ($self->isPK($arg->{name})) {
			push @set, "\t\t" . $arg->dbClassName . ' = ' . $arg->dbArgName
		}
	}
	$str .= join(",\n", @set);
	$str .= "\n\tWHERE\n";
	
	my @where = ();
	for my $arg (@{$self->{members}}) {
		if ($self->isPK($arg->{name})) {
			push @where, "\t\t" . $arg->dbClassName . ' = ' . $arg->dbArgName
		}
	}
	$str .= join(" AND\n", @where) . ";\n";
	
	$str .= "\tSELECT ROW_COUNT() as retCode;\n";
	
	$str .= "\nEND//\n\n";
	return $str;
}

sub delete {
	my $self = shift;
	my $str = "DROP PROCEDURE IF EXISTS #db#.delete$self->{name}//\n";
	$str .= "CREATE PROCEDURE #db#.delete$self->{name} (\n";
	my @args = ();
	for my $arg (@{$self->{members}}) {
		if ($self->isPK($arg->{name})) {
			push @args, "\t" . $arg->printDBArg;
		}
	}
	$str .= join(",\n", @args);
	$str .= "\n) BEGIN\n";
	$str .= "\tDELETE FROM #db#.$self->{name} WHERE\n";
	my @where = ();
	for my $arg (@{$self->{members}}) {
		if ($self->isPK($arg->{name})) {
			push @where, "\t$self->{name}.$arg->{name} = " . $arg->dbArgName;
		}
	}
	$str .= join(" AND\n", @where) . ";\n";
	
	$str .= "\tSELECT ROW_COUNT() as retCode;\n";
	
	$str .= "END;//\n\n";
	return $str;
}

sub isPK {
	my ($self, $name, $care_about_userpk) = @_;
	
	for my $i (@{$self->{pk}}) {
		if ($i eq $name) {
			if (defined $care_about_userpk) {
				!$self->{userpk}{$name} and	return 1;
				return 0;
			}
			return 1;
		}
	}
	return 0;
}

1;
__END__
