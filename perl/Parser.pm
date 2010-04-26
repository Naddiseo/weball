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

my $current_class = {};
my $focus = {};


sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			'class_t' => 3
		},
		DEFAULT => -2,
		GOTOS => {
			'class_def' => 1,
			'lines' => 2,
			'start' => 5,
			'line' => 4
		}
	},
	{#State 1
		DEFAULT => -5
	},
	{#State 2
		ACTIONS => {
			'class_t' => 3
		},
		DEFAULT => -1,
		GOTOS => {
			'class_def' => 1,
			'line' => 6
		}
	},
	{#State 3
		ACTIONS => {
			'ident_t' => 7
		}
	},
	{#State 4
		DEFAULT => -4
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
		DEFAULT => -8,
		GOTOS => {
			'attribute_list_o' => 11
		}
	},
	{#State 10
		ACTIONS => {
			'ident_t' => 12
		}
	},
	{#State 11
		DEFAULT => -7
	},
	{#State 12
		DEFAULT => -9,
		GOTOS => {
			'@2-2' => 13
		}
	},
	{#State 13
		ACTIONS => {
			"(" => 15
		},
		DEFAULT => -11,
		GOTOS => {
			'attribute_arg_list_o' => 14
		}
	},
	{#State 14
		DEFAULT => -10
	},
	{#State 15
		ACTIONS => {
			'NUM' => 16,
			'ident_t' => 17,
			")" => 19,
			'STRING' => 20
		},
		GOTOS => {
			'arg' => 18,
			'arg_list' => 21
		}
	},
	{#State 16
		DEFAULT => -17
	},
	{#State 17
		DEFAULT => -16
	},
	{#State 18
		DEFAULT => -15
	},
	{#State 19
		DEFAULT => -12
	},
	{#State 20
		DEFAULT => -18
	},
	{#State 21
		ACTIONS => {
			"," => 22,
			")" => 23
		}
	},
	{#State 22
		ACTIONS => {
			'NUM' => 16,
			'ident_t' => 17,
			'STRING' => 20
		},
		GOTOS => {
			'arg' => 24
		}
	},
	{#State 23
		DEFAULT => -13
	},
	{#State 24
		DEFAULT => -14
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
#line 23 "weball.yp"
{
		push(@{$_[1]}, $_[2]);
		$_[1];
	}
	],
	[#Rule 4
		 'lines', 1, undef
	],
	[#Rule 5
		 'line', 1, undef
	],
	[#Rule 6
		 '@1-2', 0,
sub
#line 35 "weball.yp"
{
		$current_class = {};
		$current_class->{name} = $_[2];
		$focus = $current_class;
	}
	],
	[#Rule 7
		 'class_def', 4,
sub
#line 39 "weball.yp"
{}
	],
	[#Rule 8
		 'attribute_list_o', 0, undef
	],
	[#Rule 9
		 '@2-2', 0,
sub
#line 44 "weball.yp"
{
		$focus->{attr}{$_[2]} = [];
		$focus = $focus->{attr}{$_[2]};
	}
	],
	[#Rule 10
		 'attribute_list_o', 4,
sub
#line 47 "weball.yp"
{
	}
	],
	[#Rule 11
		 'attribute_arg_list_o', 0, undef
	],
	[#Rule 12
		 'attribute_arg_list_o', 2, undef
	],
	[#Rule 13
		 'attribute_arg_list_o', 3, undef
	],
	[#Rule 14
		 'arg_list', 3, undef
	],
	[#Rule 15
		 'arg_list', 1, undef
	],
	[#Rule 16
		 'arg', 1,
sub
#line 63 "weball.yp"
{ push @{$focus}, $_[1] }
	],
	[#Rule 17
		 'arg', 1,
sub
#line 64 "weball.yp"
{ push @{$focus}, $_[1] }
	],
	[#Rule 18
		 'arg', 1,
sub
#line 65 "weball.yp"
{ push @{$focus}, $_[1] }
	]
],
                                  @_);
    bless($self,$class);
}

#line 69 "weball.yp"


1;
