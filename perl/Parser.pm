####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package Parser;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;

#line 1 "weball.yp"

use v5.10;
use Data::Dumper;

use AST::Class;

my %classes = ();

my @focus  = ();

sub fpush {
	push @focus, @_
}

sub fpop {
	pop @focus
}

sub f :lvalue {
	$focus[$#focus]
}



sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			'class_t' => 4
		},
		DEFAULT => -2,
		GOTOS => {
			'class_def' => 1,
			'outer_line' => 2,
			'lines' => 3,
			'start' => 5
		}
	},
	{#State 1
		DEFAULT => -5
	},
	{#State 2
		DEFAULT => -4
	},
	{#State 3
		ACTIONS => {
			'class_t' => 4
		},
		DEFAULT => -1,
		GOTOS => {
			'class_def' => 1,
			'outer_line' => 6
		}
	},
	{#State 4
		ACTIONS => {
			'ident_t' => 7
		}
	},
	{#State 5
		ACTIONS => {
			'' => 8
		}
	},
	{#State 6
		DEFAULT => -3
	},
	{#State 7
		DEFAULT => -6,
		GOTOS => {
			'@1-2' => 9
		}
	},
	{#State 8
		DEFAULT => 0
	},
	{#State 9
		ACTIONS => {
			":" => 10
		},
		DEFAULT => -15,
		GOTOS => {
			'attribute' => 11,
			'attribute_list_o' => 12,
			'attribute_list' => 13
		}
	},
	{#State 10
		ACTIONS => {
			'ident_t' => 14
		}
	},
	{#State 11
		DEFAULT => -18
	},
	{#State 12
		ACTIONS => {
			"{" => 15
		}
	},
	{#State 13
		ACTIONS => {
			":" => 10
		},
		DEFAULT => -16,
		GOTOS => {
			'attribute' => 16
		}
	},
	{#State 14
		DEFAULT => -19,
		GOTOS => {
			'@2-2' => 17
		}
	},
	{#State 15
		ACTIONS => {
			'string_t' => 19,
			'int_t' => 21
		},
		DEFAULT => -9,
		GOTOS => {
			'var_decl' => 18,
			'inner_lines_o' => 20,
			'inner_lines' => 22,
			'inner_line' => 23
		}
	},
	{#State 16
		DEFAULT => -17
	},
	{#State 17
		ACTIONS => {
			"(" => 25
		},
		DEFAULT => -21,
		GOTOS => {
			'attribute_arg_list_o' => 24
		}
	},
	{#State 18
		ACTIONS => {
			";" => 26
		}
	},
	{#State 19
		ACTIONS => {
			'ident_t' => 27
		}
	},
	{#State 20
		ACTIONS => {
			"}" => 28
		}
	},
	{#State 21
		ACTIONS => {
			'ident_t' => 29
		}
	},
	{#State 22
		ACTIONS => {
			'string_t' => 19,
			'int_t' => 21
		},
		DEFAULT => -8,
		GOTOS => {
			'var_decl' => 18,
			'inner_line' => 30
		}
	},
	{#State 23
		DEFAULT => -11
	},
	{#State 24
		DEFAULT => -20
	},
	{#State 25
		ACTIONS => {
			'number_t' => 31,
			'string_t' => 32,
			'ident_t' => 33,
			")" => 35
		},
		GOTOS => {
			'arg' => 34,
			'arg_list' => 36
		}
	},
	{#State 26
		DEFAULT => -12
	},
	{#State 27
		DEFAULT => -14
	},
	{#State 28
		DEFAULT => -7
	},
	{#State 29
		DEFAULT => -13
	},
	{#State 30
		DEFAULT => -10
	},
	{#State 31
		DEFAULT => -27
	},
	{#State 32
		DEFAULT => -28
	},
	{#State 33
		DEFAULT => -26
	},
	{#State 34
		DEFAULT => -25
	},
	{#State 35
		DEFAULT => -22
	},
	{#State 36
		ACTIONS => {
			"," => 37,
			")" => 38
		}
	},
	{#State 37
		ACTIONS => {
			'number_t' => 31,
			'string_t' => 32,
			'ident_t' => 33
		},
		GOTOS => {
			'arg' => 39
		}
	},
	{#State 38
		DEFAULT => -23
	},
	{#State 39
		DEFAULT => -24
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'start', 1, undef
	],
	[#Rule 2
		 'start', 0, undef
	],
	[#Rule 3
		 'lines', 2,
sub
#line 40 "weball.yp"
{
		push(@{$_[1]}, $_[2][0]);
		$_[1];
	}
	],
	[#Rule 4
		 'lines', 1,
sub
#line 44 "weball.yp"
{ $_[1]}
	],
	[#Rule 5
		 'outer_line', 1,
sub
#line 48 "weball.yp"
{ [$_[1]]}
	],
	[#Rule 6
		 '@1-2', 0,
sub
#line 52 "weball.yp"
{
		fpush(AST::Class->new($_[2]->value));
		
	}
	],
	[#Rule 7
		 'class_def', 7,
sub
#line 55 "weball.yp"
{
		
		return fpop;
	}
	],
	[#Rule 8
		 'inner_lines_o', 1, undef
	],
	[#Rule 9
		 'inner_lines_o', 0, undef
	],
	[#Rule 10
		 'inner_lines', 2, undef
	],
	[#Rule 11
		 'inner_lines', 1, undef
	],
	[#Rule 12
		 'inner_line', 2, undef
	],
	[#Rule 13
		 'var_decl', 2,
sub
#line 76 "weball.yp"
{
		f()->addVar('int', $_[2]->value)
	}
	],
	[#Rule 14
		 'var_decl', 2,
sub
#line 79 "weball.yp"
{
		f()->addVar('string', $_[2]->value)
	}
	],
	[#Rule 15
		 'attribute_list_o', 0, undef
	],
	[#Rule 16
		 'attribute_list_o', 1, undef
	],
	[#Rule 17
		 'attribute_list', 2, undef
	],
	[#Rule 18
		 'attribute_list', 1, undef
	],
	[#Rule 19
		 '@2-2', 0,
sub
#line 95 "weball.yp"
{
			fpush(AST::Class::Attr->new($_[2]->value));
			
		}
	],
	[#Rule 20
		 'attribute', 4,
sub
#line 98 "weball.yp"
{
			my $attr = fpop;
			f()->addAttr($attr);
	}
	],
	[#Rule 21
		 'attribute_arg_list_o', 0, undef
	],
	[#Rule 22
		 'attribute_arg_list_o', 2, undef
	],
	[#Rule 23
		 'attribute_arg_list_o', 3, undef
	],
	[#Rule 24
		 'arg_list', 3,
sub
#line 111 "weball.yp"
{
		f()->addArg($_[3]->value);
		#say(Dumper(f(), $_[1], $_[3]));
	}
	],
	[#Rule 25
		 'arg_list', 1,
sub
#line 115 "weball.yp"
{
		f()->addArg($_[1]->value);
	}
	],
	[#Rule 26
		 'arg', 1,
sub
#line 121 "weball.yp"
{ 
		#say "arg ident $_[1]->{value}";
		$_[1];
	#	push @{$focus}, $_[1] 
	}
	],
	[#Rule 27
		 'arg', 1,
sub
#line 126 "weball.yp"
{ 
		#say "arg NUM $_[1]->{value}";
		$_[1];
		#push @{$focus}, $_[1] 
	}
	],
	[#Rule 28
		 'arg', 1,
sub
#line 131 "weball.yp"
{ 
		#say "arg string $_[1]->{value}";
		$_[1];
	#	push @{$focus}, $_[1] 
	}
	]
],
                                  @_);
    bless($self,$class);
}

#line 139 "weball.yp"


1;
