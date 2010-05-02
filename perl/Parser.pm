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
		DEFAULT => -28,
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
		DEFAULT => -31
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
		DEFAULT => -29,
		GOTOS => {
			'attribute' => 16
		}
	},
	{#State 14
		DEFAULT => -32,
		GOTOS => {
			'@4-2' => 17
		}
	},
	{#State 15
		ACTIONS => {
			'bool_t' => 18,
			'dbfunction_t' => 20,
			'double_t' => 23,
			'string_t' => 24,
			'uint_t' => 27,
			'int_t' => 29
		},
		DEFAULT => -9,
		GOTOS => {
			'var_decl' => 22,
			'var_type' => 19,
			'dbfunction_decl' => 26,
			'inner_lines_o' => 25,
			'inner_lines' => 28,
			'inner_line' => 21
		}
	},
	{#State 16
		DEFAULT => -30
	},
	{#State 17
		ACTIONS => {
			"(" => 31
		},
		DEFAULT => -36,
		GOTOS => {
			'attribute_arg_list_o' => 30
		}
	},
	{#State 18
		DEFAULT => -25
	},
	{#State 19
		ACTIONS => {
			'ident_t' => 32
		}
	},
	{#State 20
		ACTIONS => {
			'ident_t' => 33
		}
	},
	{#State 21
		DEFAULT => -11
	},
	{#State 22
		ACTIONS => {
			";" => 34
		}
	},
	{#State 23
		DEFAULT => -27
	},
	{#State 24
		DEFAULT => -26
	},
	{#State 25
		ACTIONS => {
			"}" => 35
		}
	},
	{#State 26
		DEFAULT => -13
	},
	{#State 27
		DEFAULT => -24
	},
	{#State 28
		ACTIONS => {
			'bool_t' => 18,
			'dbfunction_t' => 20,
			'double_t' => 23,
			'string_t' => 24,
			'uint_t' => 27,
			'int_t' => 29
		},
		DEFAULT => -8,
		GOTOS => {
			'var_decl' => 22,
			'var_type' => 19,
			'dbfunction_decl' => 26,
			'inner_line' => 36
		}
	},
	{#State 29
		DEFAULT => -23
	},
	{#State 30
		DEFAULT => -33
	},
	{#State 31
		ACTIONS => {
			'number_t' => 37,
			'true_t' => 42,
			'string_t' => 41,
			'ident_t' => 43,
			")" => 44,
			'false_t' => 39
		},
		GOTOS => {
			'arg' => 38,
			'arg_list' => 40
		}
	},
	{#State 32
		DEFAULT => -21,
		GOTOS => {
			'@3-2' => 45
		}
	},
	{#State 33
		DEFAULT => -14,
		GOTOS => {
			'@2-2' => 46
		}
	},
	{#State 34
		DEFAULT => -12
	},
	{#State 35
		DEFAULT => -7
	},
	{#State 36
		DEFAULT => -10
	},
	{#State 37
		DEFAULT => -42
	},
	{#State 38
		DEFAULT => -40
	},
	{#State 39
		DEFAULT => -44
	},
	{#State 40
		ACTIONS => {
			"," => 47,
			")" => 48
		}
	},
	{#State 41
		DEFAULT => -45
	},
	{#State 42
		DEFAULT => -43
	},
	{#State 43
		DEFAULT => -41
	},
	{#State 44
		DEFAULT => -37
	},
	{#State 45
		ACTIONS => {
			":" => 10
		},
		DEFAULT => -28,
		GOTOS => {
			'attribute' => 11,
			'attribute_list_o' => 49,
			'attribute_list' => 13
		}
	},
	{#State 46
		ACTIONS => {
			"(" => 50
		}
	},
	{#State 47
		ACTIONS => {
			'number_t' => 37,
			'true_t' => 42,
			'string_t' => 41,
			'ident_t' => 43,
			'false_t' => 39
		},
		GOTOS => {
			'arg' => 51
		}
	},
	{#State 48
		DEFAULT => -38
	},
	{#State 49
		DEFAULT => -22
	},
	{#State 50
		ACTIONS => {
			'number_t' => 37,
			'true_t' => 42,
			'string_t' => 41,
			'ident_t' => 43,
			'false_t' => 39
		},
		DEFAULT => -35,
		GOTOS => {
			'arg' => 38,
			'fn_arg_list_o' => 53,
			'arg_list' => 52
		}
	},
	{#State 51
		DEFAULT => -39
	},
	{#State 52
		ACTIONS => {
			"," => 47
		},
		DEFAULT => -34
	},
	{#State 53
		ACTIONS => {
			")" => 54
		}
	},
	{#State 54
		ACTIONS => {
			":" => 10
		},
		DEFAULT => -28,
		GOTOS => {
			'attribute' => 11,
			'attribute_list_o' => 55,
			'attribute_list' => 13
		}
	},
	{#State 55
		ACTIONS => {
			"{" => 56
		}
	},
	{#State 56
		ACTIONS => {
			'bool_t' => 18,
			'double_t' => 23,
			'string_t' => 24,
			'int_t' => 29,
			'uint_t' => 27
		},
		DEFAULT => -16,
		GOTOS => {
			'var_decl' => 60,
			'var_type' => 19,
			'code_inner_lines_o' => 59,
			'code_inner_lines' => 58,
			'code_inner_line' => 57
		}
	},
	{#State 57
		DEFAULT => -19
	},
	{#State 58
		ACTIONS => {
			'bool_t' => 18,
			'double_t' => 23,
			'string_t' => 24,
			'int_t' => 29,
			'uint_t' => 27
		},
		DEFAULT => -17,
		GOTOS => {
			'var_decl' => 60,
			'var_type' => 19,
			'code_inner_line' => 61
		}
	},
	{#State 59
		ACTIONS => {
			"}" => 62
		}
	},
	{#State 60
		ACTIONS => {
			";" => 63
		}
	},
	{#State 61
		DEFAULT => -18
	},
	{#State 62
		DEFAULT => -15
	},
	{#State 63
		DEFAULT => -20
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
		 'inner_line', 1, undef
	],
	[#Rule 14
		 '@2-2', 0,
sub
#line 77 "weball.yp"
{fpush(AST::Class::DBFunction->new($_[2]->value))}
	],
	[#Rule 15
		 'dbfunction_decl', 10,
sub
#line 78 "weball.yp"
{
			my $dbf = fpop();
			f()->addDBF($dbf);
		}
	],
	[#Rule 16
		 'code_inner_lines_o', 0, undef
	],
	[#Rule 17
		 'code_inner_lines_o', 1, undef
	],
	[#Rule 18
		 'code_inner_lines', 2, undef
	],
	[#Rule 19
		 'code_inner_lines', 1, undef
	],
	[#Rule 20
		 'code_inner_line', 2, undef
	],
	[#Rule 21
		 '@3-2', 0,
sub
#line 99 "weball.yp"
{
		fpush(AST::Class::Var->new($_[2]->value, $_[1]))
		}
	],
	[#Rule 22
		 'var_decl', 4,
sub
#line 102 "weball.yp"
{
		my $var = fpop();
		f()->addVar($var);
	}
	],
	[#Rule 23
		 'var_type', 1,
sub
#line 109 "weball.yp"
{ $_[1]->value }
	],
	[#Rule 24
		 'var_type', 1,
sub
#line 110 "weball.yp"
{ $_[1]->value }
	],
	[#Rule 25
		 'var_type', 1,
sub
#line 111 "weball.yp"
{ $_[1]->value }
	],
	[#Rule 26
		 'var_type', 1,
sub
#line 112 "weball.yp"
{ $_[1]->value }
	],
	[#Rule 27
		 'var_type', 1,
sub
#line 113 "weball.yp"
{ $_[1]->value }
	],
	[#Rule 28
		 'attribute_list_o', 0, undef
	],
	[#Rule 29
		 'attribute_list_o', 1, undef
	],
	[#Rule 30
		 'attribute_list', 2, undef
	],
	[#Rule 31
		 'attribute_list', 1, undef
	],
	[#Rule 32
		 '@4-2', 0,
sub
#line 127 "weball.yp"
{
			fpush(AST::Class::Attr->new($_[2]->value));
			
		}
	],
	[#Rule 33
		 'attribute', 4,
sub
#line 130 "weball.yp"
{
			my $attr = fpop;
			f()->addAttr($attr);
	}
	],
	[#Rule 34
		 'fn_arg_list_o', 1, undef
	],
	[#Rule 35
		 'fn_arg_list_o', 0, undef
	],
	[#Rule 36
		 'attribute_arg_list_o', 0, undef
	],
	[#Rule 37
		 'attribute_arg_list_o', 2, undef
	],
	[#Rule 38
		 'attribute_arg_list_o', 3, undef
	],
	[#Rule 39
		 'arg_list', 3,
sub
#line 148 "weball.yp"
{
		f()->addArg($_[3]->value);
		#say(Dumper(f(), $_[1], $_[3]));
	}
	],
	[#Rule 40
		 'arg_list', 1,
sub
#line 152 "weball.yp"
{
		f()->addArg($_[1]->value);
	}
	],
	[#Rule 41
		 'arg', 1, undef
	],
	[#Rule 42
		 'arg', 1, undef
	],
	[#Rule 43
		 'arg', 1, undef
	],
	[#Rule 44
		 'arg', 1, undef
	],
	[#Rule 45
		 'arg', 1, undef
	]
],
                                  @_);
    bless($self,$class);
}

#line 166 "weball.yp"


1;
