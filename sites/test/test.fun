/-- fun test file --/


site test {
    extern java org.**
    extern java java.**

    copyright [/
        Copyright &copy; 2004-2016 by <a href="http://www.fundev.org">fundev.org</a><br>
    /]

    /------------------------------------------------------------------/
    /---                       Site options                         ---/
    /------------------------------------------------------------------/

    files_first = false
    sandbox_enabled = true

    /------------------------------------------------------------------/
    /---                    Request parameters                      ---/
    /------------------------------------------------------------------/

    dynamic command_param(request r) = r.params["command"];


    /------------------------------------------------------------------/
    /---                         Test cases                         ---/
    /------------------------------------------------------------------/

    /** All standard test cases **/
    test_case[] all_tests = [ abstract_test, alias_test, aliased_array_test,
                              aliased_sub_child_test, arithmetic_test, array_test,
                              array_arithmetic_test, array_builder_test,
                              array_element_builder_test, array_element_child_array_test,
                              array_element_type_test, array_parameter_test, 
                              base_child_subclass_test, bitwise_array_operator_test, border_layout_test,
                              cache_test, cached_aliased_parameter_test, cached_array_test,
                              cached_child_of_alias_test, cached_external_object_test, 
                              cached_identity_test, cached_object_test, char_utilities_test,
                              children_of_global_test, children_of_overridden_super_test, 
                              children_of_parameterized_super_test, children_of_static_test,
                              collection_parse_test, collection_operators_test, collection_utilities_test,
                              compass_layout_test, complex_array_test, conditional_inheritance_test,
                              count_test, corresponding_super_test, dynamic_argument_list_test, 
                              dynamic_array_test, dynamic_array_element_child_test,
                              dynamic_code_block_test, dynamic_keep_test, dynamic_table_test, 
                              expression_arg_type_test, expression_comprehension_test, 
                              external_argument_test, 
                              external_array_parameter_test, external_map_array_test,
                              external_test, higher_order_def_test, indexed_alias_test, 
                              keep_test, keep_prefix_test, keep_scope_test,
                              lateral_inheritance_test, logic_test, loop_parameter_test, 
                              mapped_array_table_test,
                              multidimensional_array_test, multidimensional_table_test,
                              multiple_inheritance_test, name_resolution_test, 
                              nested_cached_identity_test, nested_keep_test, 
                              nested_parameter_test, 
                              object_child_test, over_inheritance_test, owner_type_test,
                              parameter_test, parameter_child_array_test,
                              passed_cache_test, recursion_test, recursive_dynamic_array_test,
                              redirection_test, return_type_test, self_referential_update_test,
                              serialization_test, simple_inheritance_test, simple_insert_test,
                              simple_instantiation_test, sort_test, special_names_test, 
                              super_child_test, super_in_sub_test, 
                              table_test, table_element_type_test, table_parameter_test,
                              text_utilities_test, this_type_test, type_test ]

    /** Global statistics table **/
    global int global_stats{} = {}

    /** Table for tabulating test results. **/
    int results{} = {}
    
    /** Session data **/
    int num_page_views(int n) = n    
    

    /** Base class for test cases. **/
    base_test {
        keep in results: int bad = results["bad"] + 1;
        keep in results: int good = results["good"] + 1;

        int category [?]
        name [?]
        key [?]
        
        boolean need_exact_match = true

        tabulate(boolean success) {
            if (success) {
                eval(good);
            } else {
                eval(bad);
            }
        }
    }

    base_test test_case {

        expected [/]

        [/
           <table bgcolor="#F7F1DD" cellpadding="2" cellspacing="4" width="400">
           <tr><th bgcolor="#CCBB77" colspan="2">{= name; =}</th></tr>
        /]

        if (expected) [/
           <tr><td><b>Expected:</b></td><td>{= expected; =} </td></tr>
        /]

        [/ <tr><td><b>Result:</b></td> /]

        if (need_exact_match && sub != expected) [/
            <td style="color: red">
        /] else [/
            <td>
        /]
        sub;

        [/ </td></tr></table> /]

        if (expected) {
            tabulate(sub == expected);
        }
    }

    /-- empty test to test test_case --/
    test_case empty_test {
        int category = -1
        name = "Empty Test"
        key = "empty"
        expected = ""

        tabulate(true);
    }

    /** Test case categories. **/
    int syntax = 0
    int logic = 1
    int arithmetic = 2
    int definitions = 3
    int instantiations = 4
    int types = 5
    int parameters = 6
    int collections = 7
    int external_objects = 8
    int redirection = 9
    int scope = 10
    int access = 11
    int recursion = 12
    int caching = 13
    int requests = 14
    int sessions = 15
    int database = 16
    int layouts = 17
    int utilities = 18
    int highest_category = 18


    string[] category_titles = [ "Syntax", "Logic", "Arithmetic", "Definitions", "Instantiations", "Types", "Parameters", "Collections",
                                 "External Objects", "Redirection", "Scope", "Access", "Recursion", "Caching",
                                 "Requests", "Sessions", "Database", "Layouts", "Utilities", "Dynamic Code" ]

    public test_case syntax_test {
        int category = syntax
        name = "Syntax Test"
        key = "syntax"
        
        // not yet devised
    }


    public test_case arithmetic_test {
        int category = arithmetic
        name = "Arithmetic Test"
        key = "arithmetic"

        expected = "ABC"

        int n = 2
        float f = 1.999999999999999
        long x = 0x7fffffffffffffffL

        float expr1 = (n * f) / f
        if (expr1 == 2.0) [/ A /]

        long expr2 = (n - x) * -1 + n
        if (expr2 == x) [/ B /]

        int expr3 = (int) f
        if (expr3 == 1) [/ C /]
    }


    public test_case array_arithmetic_test {
        int category = arithmetic
        name = "Array Arithmetic Test"
        key = "array arithmetic"

        expected = "ABCDEFGHIJKL"

        array_1[2] = [ "A", "B" ]
        array_2[2] = [ "C", "D" ]
        array_3[] = [ "E", "F" ]
        array_4[] = [ "G", "H" ]
        array_5[2] = [ "I", "J" ]
        array_6[] = [ "K", "L" ]

        sum_1[] = array_1 + array_2
        sum_2[] = array_3 + array_4
        sum_3[] = array_5 + array_6

        for x in sum_1 { x; }
        for x in sum_2 { x; }
        for x in sum_3 { x; }
    }
    
    public test_case bitwise_array_operator_test {
        int category = collections
        name = "Bitwise Array Operator Test"
        key = "bitwise array"
        
        expected = "ABCD"
        
        byte[2] array_1 = [ #FF, #00 ]
        byte[2] array_2 = [ #AA, #55 ]
        
        byte[] and_array = (array_1 & array_2)
        byte[] or_array = (array_1 | array_2)
        byte[] xor_array = (array_1 ^ array_2)
        byte[] not_array = ~array_1
    
        if (and_array[0] == #AA && and_array[1] == #00) [/ A /]
        else [/ x /]
            
        if (or_array[0] == #FF && or_array[1] == #55) [/ B /]
        else [/ x /]
            
        if (xor_array[0] == #55 && xor_array[1] == #55) [/ C /]
        else [/ x /]
        
        if (not_array[0] == #00 && not_array[1] == #FF) [/ D /]
        else [/ x /]
    }

bat {=

byte[2] bb = [ 257, 256 ]

bb[0];

=}


    public test_case name_resolution_test {
        int category = definitions
        name = "Name Resolution Test"
        key = "resolution"

        expected = "ABCDEFGHI"

        test_set_1 {

            super_1 {
                defn [/ X /]
            }

            super_1 test_local_def {
                defn [/ A /]

                defn;
            }

            super_2 {
                defn [/ B /]
            }

            super_2 test_class_def {
                defn;
            }

            defn [/ C /]

            test_container_local_def {
                defn;
            }

            test_local_def;
            test_class_def;
            test_container_local_def;
        }


        super_set_2 {
            defn [/ D /]
        }

        super_set_2 test_set_2 {

            test_container_class_def {
                defn;
            }

            test_container_class_def;
        }

        test_set_3 {
            container_3 {
                defn [/ E /]
                super_3 [/]
            }

            container_3.super_3 test_class_container_def {
                defn;
            }

            test_class_container_def;
        }
        
        test_set_4 {
            `back-quoted name` [/ F /]
            
            normal_parent {
                `back-quoted child name` [/ G /]
            }
            
            normal_function(`back-quoted parameter`) {
                `back-quoted parameter`;
            }
            
            `back-quoted name` normal_sub [/ I /]
                        
            `back-quoted name`;
            normal_parent.`back-quoted child name`;
            normal_function("H");
            normal_sub;
        }
        
        test_set_1;
        test_set_2;
        test_set_3;
        test_set_4;
    }


    static stat_super {
        a = "A"
        b = "x"
        c = "x"
        d = "x"
        e = "x"
        fg[] = [ "x" ]
        hi = (b == "B" ? "H" : (c == "C" ? "I" : "x"))
    }
    
    static stat_super stat_sub_1 {
        a = "x"
        b = "B"
        c = "x"
        d = "D"
        e = "x"
        fg[] = [ "F" ]
    }
    
    static stat_super stat_sub_2 {
        a = "x"
        b = "x"
        c = "C"
        d = "x"
        e = "E"
        fg[] = [ "G" ]
    }
    
    stat_super[] stat_array = [ stat_sub_1, stat_sub_2 ]


    public test_case children_of_static_test {
        int category = scope
        name = "Children of Static Test"
        key = "children_of_static"
        
        expected = "ABCDEFGHI"

        eval(stat_super.a);
        eval(stat_super.b);
        eval(stat_super.c);
        eval(stat_super.d);
        eval(stat_super.e);
        
        eval(stat_sub_1.a);
        eval(stat_sub_1.b);
        eval(stat_sub_1.c);
        eval(stat_sub_1.d);
        eval(stat_sub_1.e);
        
        eval(stat_sub_2.a);
        eval(stat_sub_2.b);
        eval(stat_sub_2.c);
        eval(stat_sub_2.d);
        eval(stat_sub_2.e);
        
        stat_super.a;
        stat_sub_1.b;
        stat_sub_2.c;
        stat_array[0].d;
        stat_array[1].e;        
        for stat_super s in stat_array {
            s.fg[0];
        }
        
        stat_sub_1.hi;
        stat_sub_2.hi;
        
    }
    
ss1 {=
        stat_sub_1.hi;
    stat_sub_1.b;
=}    


    global glob_super {
        a = "A"
        b = "x"
        c = "x"
        d = "x"
        e = "x"
        fg[] = [ "x" ]
        hi = (b == "B" ? "H" : (c == "C" ? "I" : "x"))
    }
    
    global glob_super glob_sub_1 {
        a = "x"
        b = "B"
        c = "x"
        d = "D"
        e = "x"
        fg[] = [ "F" ]
    }
    
    global glob_super glob_sub_2 {
        a = "x"
        b = "x"
        c = "C"
        d = "x"
        e = "E"
        fg[] = [ "G" ]
    }
    
    glob_super[] glob_array = [ glob_sub_1, glob_sub_2 ]

    public test_case children_of_global_test {
        int category = scope
        name = "Children of Global Test"
        key = "children_of_global"
        
        expected = "ABCDEFGHI"

        eval(glob_super.a);
        eval(glob_super.b);
        eval(glob_super.c);
        eval(glob_super.d);
        eval(glob_super.e);
        
        eval(glob_sub_1.a);
        eval(glob_sub_1.b);
        eval(glob_sub_1.c);
        eval(glob_sub_1.d);
        eval(glob_sub_1.e);
        
        eval(glob_sub_2.a);
        eval(glob_sub_2.b);
        eval(glob_sub_2.c);
        eval(glob_sub_2.d);
        eval(glob_sub_2.e);
        
        glob_super.a;
        glob_sub_1.b;
        glob_sub_2.c;
        glob_array[0].d;
        glob_array[1].e;        
        for glob_super g in glob_array {
            g.fg[0];
        }
        
        glob_sub_1.hi;
        glob_sub_2.hi;
        
    }

    public test_case children_of_overridden_super_test {
        int category = instantiations
        name = "Children of Overridden Super Test"
        key = "base_child_subclass"

        expected = "ABCDE"
    
    
        super_parent {
            a [/ A /]
            b [/ B /]
            char c = 'C'
            d [/ D /]
            char e = 'E'
            show(char x) = x
            
            "x";
        }
    
        super_parent sub_parent {
            dynamic show(x) = x

            a;
            (true ? b : "x");
            show(: c :);
        }
        
        sub_parent sub_of_sub {
            d;
        }

        super_parent single_const_parent {
            show(: e :);
        }

        sub_parent;
        sub_of_sub;
        single_const_parent;
    }
    

    public test_case base_child_subclass_test {
        int category = types
        name = "Base Child Subclass Test"
        key = "base_child_subclass"

        expected = "ABCD"

        base_owner {
            a [/ A /]
            b [/ B /]
            b bb [/]
            c [/ C /]
            d(x) = x
        }
        
        base_owner sub_owner {
            a asub [/]
            bb bsub [/]
            c cc [/]
            cc csub [/]
            d(y) dd(y) [/]
            dd(z) dsub(z) [/] 
        }
       
       sub_owner.asub;
       sub_owner.bsub;
       sub_owner.csub;
       sub_owner.dsub("D");
    }


    public test_case corresponding_super_test {
        int category = types
        name = "Corresponding Super Test"
        key = "corresponding_super"

        expected = "ABCDEFGH"

        a = "A"
        b = "x"
        c = "C"
        d = "x"
        ef = "E"
        
        local_defs {
            this a [/]
            this b = "B"
            this c [/]
            this d = "D"
            this ef {
                super;
                "F";
            }
            
            gh {
                "G";
                sub;
            }
            
            a;
            b;
        }
        
        local_defs local_subs {
            this gh = "H"
        }
        
        local_defs;
        local_defs.c;
        local_defs.d;
        local_defs.ef;
        local_subs.gh;  
    }       


    public test_case super_in_sub_test {
        int category = instantiations
        name = "Super In Sub Test"
        key = "super_in_sub"

        expected = "ABCD"

        mo(x) {
            x;
            sub;
        }
        
        mo(y) momo(y) {
            "C";
        }
        
        mo(z) mosub(z) {
            momo("B");
            mo("D");
        }
        
        mosub("A");
    }
    
    
    public test_case special_names_test {
        int category = syntax
        name = "Special Names Test"
        key = "special_names"
        
        expected = "ABCDEFGHIJKLMNO"
        
        z {
            container.c;
        }
        
        a {
           
           b {
           
               x {
               
                   y {
                       c [/ C /]

                       z;
                   }

                   owner.owner;
                   owner;
                   y;                   
                }          
               
                "B";
            }
           
            "A";
        }
        
        l = "L"
        l_def = l.def
        
        mn_base {
        
            m [/ x /]
            n [/ x /]
            
            show_m = owner.m;
            show_n { 
                owner.n;
            }
            show_m;
        }
        
        mn_base mn {
            m [/ M /]
            n [/ N /]
        }
        
        otype [/]
        
        otype oinstance {
           if (super isa otype)       [/ O /] else [/ x /]
        }
                
        a.b.x;
       
        if (owner isa definition)     [/ D /] else [/ x /]
        if (container isa definition) [/ E /] else [/ x /]
        if (this isa definition)      [/ F /] else [/ x /]
        if (super isa definition)     [/ G /] else [/ x /]
        if (sub isa definition)       [/ H /] else [/ x /]
        if (site isa definition)      [/ I /] else [/ x /]
        if (core isa definition)      [/ J /] else [/ x /]
        if (def isa definition)       [/ K /] else [/ x /]
        
        l_def.instantiate;
        
        mn;
        mn.show_n;
        oinstance;
    }

    public test_case this_type_test {    
        int category = types
        name = "This Type Test"
        key = "this_type"
        
        expected = "ABCDEF"

        super_def {
            c [/ x /]
            d [/ x /]
            f [/ F /]
        }
        
        super_def this_def {
            c [/ C /]
            d [/ D /]
            e [/ E /]
            
            if (this isa super_def) [/ A /] else [/ x /]
            if (this isa this_def)  [/ B /] else [/ x /]
            show_c(this);
            show_d(this);
            this.e;
            this.f;
        }
                 
       
        show_c(this_def td),(y) {
            with (td) {
                td.c;
            } else {
                "y";
            }
        }

        show_d(super_def sd),(z) {
            with (sd) {
                sd.d;
            } else {
                "z";
            }
         }
         
         this_def;       
    }

    public test_case owner_type_test {
        int category = types
        name = "Owner Type Test"
        key = "owner_type"
        
        expected = "ABCDEFGHI"
    
        owner_base {
        
            id = owner.type;
            
            "X";
        }
        
        owner_base A [/]
        
        A B [/]
        
        owner_base C [/]
        
        C D [/]
        
        owner_base owner_array_1[] = [ C, D ]
        
        owner_base E {
            id;
        }
        
        owner_base F {
            id;
        }
        
        F G [/]
        
        owner_base owner_array_2[] = [ F, G ]
        
        A.id;
        B.id;
        for owner_base ob in owner_array_1 {
           ob.id;
        }
        E;
        for owner_base ob in owner_array_2 {
           ob;
        }
    
        owner_checker {
            if (owner isa right_owner) [/ H /]
            else                       [/ I /]        
        } 
    
        right_owner {
            owner_checker has_right_owner [/]
        }
        
        wrong_owner {
            owner_checker has_wrong_owner [/]
        }
        
        right_owner.has_right_owner;
        wrong_owner.has_wrong_owner;
    
    }

ott {=
        owner_base {
        
            id = owner.type;
            
            "X";
        }
        
        owner_base A [/]
        
        A B [/]
        
        owner_base C [/]
        
        C D [/]
        
        owner_base owner_array_1[] = [ C, D ]
        
        owner_base E {
            id;
        }
        
        owner_base F {
            id;
        }
        
        F G [/]
        
        owner_base owner_array_2[] = [ F, G ]
        
        A.id;
        B.id;
        for owner_base ob in owner_array_1 {
           ob.id;
        }
        E; 
        for owner_base ob in owner_array_2 {
           ob;
        }
=}

    public test_case simple_instantiation_test {
        int category = instantiations
        name = "Simple Instantiation Test"
        key = "instantiation"

        expected = "ABCDEFGH"

        a = "A"
        b [/ B /]
        cprime = "C"
        c = cprime
        dprime = "D"
        d {= dprime; =}
        char e = 'E'
        f {= [/ F /] =}
        g [/ {= [/ G /] =} /]
        h [``H``]

        a;
        b;
        c;
        d;
        e;
        f;
        g;
        h;
    }


    public test_case simple_inheritance_test {
        int category = instantiations
        name = "Simple Inheritance Test"
        key = "inheritance"

        expected = "ABCDEFGHIJKLM"

        super_1 {
           [/ A /]
           sub;
           [/ E /]
        }
        super_1 sub_1 {
            [/ B /]
            sub;
            [/ D /]
        }
        sub_1 sub_sub_1 [/ C /]


        super_super_2 [/ H /]
        super_super_2 super_2 {
            [/ G /]
            super;
            [/ I /]
        }
        super_2 sub_2 {
            [/ F /]
            super;
            [/ J /]
        }
        
        super_3 {
           [/ K /]
           sub;
           [/ M /]
        }
        super_3 sub_null [/]

        sub_null sub_sub_3 [/ L /]
        

        sub_sub_1;
        sub_2;
        sub_sub_3;
    }


    public test_case multiple_inheritance_test {
        int category = instantiations
        name = "Multiple Inheritance Test"
        key = "multiple_inheritance"

        expected = "ABCDEFGHIJKLMNOPQ"

        super_1 {
           [/ A /]
           sub;
           [/ C /]
        }
        super_1 sub_1 [/ B /]

        super_2 {
           [/ D /]
           sub;
           [/ F /]
        }
        super_2 sub_2(int n) [/ E /]

        super_3 {
           [/ G /]
           sub;
           [/ I /]
        }
        dynamic super_3 sub_3(x) {
            x;
        }
        
        super_4 sub_4 {
            j [/ J /]
        }
        
        super_4 {
            k [/ K /]
        }

        dynamic sub_1,sub_2(i),sub_3(c),sub_4 test_sub(),(int i),(c) [/]

        dynamic super_5(x) {
            x;
        }


        dynamic super_5(x) sub_5(x) {
            [/ L /]
            super;
            [/ N /]
        }

        dynamic super_5(z) sub_6(y, z) {
            [/ O /]
            super;
            [/ Q /]
        }

        dynamic sub_5(a),sub_6(b, c) test_super(a),(b, c) {
            super;
        }

        test_sub;
        test_sub(1);
        test_sub("H");
        test_sub.j;
        test_sub.k;
        test_super('M');
        test_super('x', 'P');
        
    }


    public test_case lateral_inheritance_test {
        int category = instantiations
        name = "Lateral Inheritance Test"
        key = "lateral_inheritance"

        expected = "ABCDEFGHIJKLMN"
        
        super_1 {
            [/ A /]
            sub;
            [/ G /]
        }
        
        next_1 {
            [/ B /]
            next;
            [/ F /]
        }
        
        next_2 {
            [/ C /]
            next;
            [/ E /]
        }
        
        next_3 {
            next;
        }
       
        next_1, next_2, next_3, super_1 sub_1 {
            [/ D /]
        }
      
        super_2 {
            [/ K /]
        }
        
        next_4 {
            [/ I /]
            next;
            [/ M /]
        }
        
        next_5 {
            next;
        }
        
        next_6 {
            [/ J /]
            next;
            [/ L /]
        }
        
        next_4, next_5, next_6, super_2 sub_2 {
            [/ H /]
            super;
            [/ N /]
        }

        sub_1;
        sub_2;
    }


    public test_case over_inheritance_test {
        int category = instantiations
        name = "Overinheritance Test"
        key = "over_inheritance"

        expected = "ABCDEFGHIJKLM"

        super_1 {
            under_1 {
                [/ A /]
                sub;
                [/ E /]
            }
        }


        super_1 sub_1 {
            this under_1 {
                [/ B /]
                sub;
                [/ D /]
            }
        }
        
        sub_1 sub_sub_1 { 
            this under_1 [/ C /]
        }


        super_super_2 {
            over_2 [/ H /]
        }
        
        super_super_2 super_2 {
            this over_2 {
                [/ G /]
                super;
                [/ I /]
            }
        }
        super_2 sub_2 {
           this over_2 {
                [/ F /]
                super;
                [/ J /]
            }
        }
        
        super_3 {
            under_3 {
                [/ K /]
                sub;
                [/ M /]
            }
        }
        super_3 sub_null [/]

        sub_null sub_sub_3 {
            this under_3 [/ L /]
        }
        
        sub_sub_1.under_1;
        sub_2.over_2;
        sub_sub_3.under_3;
    }


    public test_case abstract_test {
        int category = instantiations
        name = "Abstract Definition Test"
        key = "abstract"
        
        expected = "ABCDEF"
        
        test_super {
            test_child [?]
        
            [/ A /] catch [/ x /]
        }
        
        test_super test_sub_1 {
            [/ B /] catch [/ x /]
        }
        
        test_super test_sub_2 {
            {
                test_child;
                [/ x /]
            } catch [/ C /]
        }

        test_super test_sub_3 {
            test_child [/]
        
            {
                test_child;
                [/ D /]
            } catch [/ x /]
        }
        
        test_abs [?]
        test_nonabs [/]
              
        test_super;
        test_sub_1;
        test_sub_2;
        test_sub_3;
        
        with (test_abs) [/ x /]
        else [/ E /]
        
        with (test_nonabs) [/ F /]
        else [/ x /]
        
    }

at {=
    test_super {
        test_child [?]
    
        [/ A /] catch [/ x /]
    }
    
    test_super test_sub_1 {
        [/ B /] catch [/ x /]
    }
    
    test_super test_sub_2 {
        {
            test_child;
            [/ x /]
        } catch [/ C /]
    }
    test_sub_2;
=}


    public test_case return_type_test {
        int category = types
        name = "Return Type Test"
        key = "return_types"
        
        expected = "ABCD"
        
        dynamic boolean return_boolean(int x) {
            if (x > 0) {
                true;
            } else {
                false;
            }
        }
        
        dynamic int return_int(boolean y) {
            if (y) {
                2;
            } else {
                3;
            }
        }

        val1 = return_boolean(1)
        val2 = return_boolean(-1)
        val3 = return_int(true)
        val4 = return_int(false)
        
        if (val1 isa boolean) [/ A /]
        else [/ x /]
        if (val2 isa boolean) [/ B /]
        else [/ x /]
        
        ('A' + val3);
        ('A' + val4);
    }


    public test_case alias_test {
        int category = instantiations
        name = "Alias Test"
        key = "alias"

        expected = "ABCDEFGHIJKLMNO"

        /** aliased instantiation **/
        alias_target = "A"
        aliased_instantiation = alias_target

        /** doubly aliased instantiation **/
        second_alias_target = "B"
        first_alias_target = second_alias_target
        doubly_aliased_instantiation = first_alias_target

        /** child of alias **/
        aliased_parent_superclass parent {
            child = "C"
        }
        aliased_parent_superclass aliased_parent = parent
        
        /** superclass of aliased parent; the subclass alias should override this **/ 
        aliased_parent_superclass {
            child = "x"
        }

        /** child of double alias **/
        another_parent {
            child = "D"
        }
        aliased_parent_superclass another_aliased_parent = another_parent
        aliased_parent_superclass doubly_aliased_parent = another_aliased_parent

        /** aliased parameters **/
        aliased_parameter_parent(x, y) {
            aliased_parameter_1 = x
            aliased_parameter_2 = y

            child {
                aliased_parameter_2;
            }

            aliased_parameter_1;
            child;
        }

        /** aliased table element **/
        table_parent {
            element{} = { "g": "G" }
        }

        aliased_element = table_parent.element["g"]

        /** subclass child referenced in an alias **/
        sub_parent_super subclassed_aliased_parent {
            aliased_child = "I"
            another_aliased_child = another_child
        }

        top_parent sub_parent_super = subclassed_aliased_parent_target(aliased_child)

        top_parent {
            aliased_child = "H"
            another_child = "x"
        }

        subclassed_aliased_parent_target(x) {
            child = x
            another_child = "J"
        }

        parent_with_param(y) {
            child = y
        }
        
        aliased_parent_with_param = parent_with_param('K').child;
        
        aliased_param_with_arg_interface {
            aliased_arg_param_1 [/ x /]
            aliased_arg_param_2 [/ z /]
        }
        
        aliased_param_with_arg_interface aliased_param_with_arg(w, z) {
            aliased_arg_param_1 = w
            aliased_arg_param_2 = z
        }
        
        aliased_param_container(aliased_param_with_arg_interface apwai) {
            aliased_param_with_arg_interface aliased_aliased_param = apwai
        
            apwai.aliased_arg_param_1;
            aliased_aliased_param.aliased_arg_param_2;
        }  
          
        btype {
            c = "x"
        }

        atype {
            btype b [/]
        }
    
        atype atype_alias = atype_instance("N")
    
        atype atype_instance(z) {
            bb = z
            
            btype b {
                c = z
            }
        }

        a_container(atype a) {
            a.b.c;
        }
        
        another_container(atype a) {
            atype aa = a
        }

        aliased_instantiation;
        doubly_aliased_instantiation;
        aliased_parent.child;
        doubly_aliased_parent.child;
        aliased_parameter_parent("E", "F");
        aliased_element;
        sub_parent_super.child;
        subclassed_aliased_parent.child;
        subclassed_aliased_parent.another_aliased_child;
        aliased_parent_with_param;
        aliased_param_container(aliased_param_with_arg("L", "M"));
        a_container(atype_alias);
        another_container(atype_instance("O")).aa.bb;
    }


    public test_case indexed_alias_test {
        int category = instantiations
        name = "Indexed Alias Test"
        key = "indexed_alias"

        expected = "ABCDEFG"

        ia_target {
            child [/ B /]
            [/ A /]  
        }
               
        ia_array[] = [ ia_target, ia_table, ia_table_2, "X" ]
        ia_array_2[] = [ "X", "D" ]
        
        ia_table{} = { "c": "C", "d": ia_array_2 }
        ia_table_2{} = { "E": "x", "F": "x", "G": "x" }
        
        ia_array_type[] = []
        
        indexed_alias = ia_array[0]
        indexed_alias_to_table{} = ia_array[1]
        indexed_alias_to_table_2{} = ia_array[2]
        ia_array_type alias_to_array = ia_array
        ia_array_type complex_def_returning_array {
            if (1) {
                ia_array;
            }
        }
        ia_2_to_table_2{} = alias_to_array[2]
        ia_3_to_table_2{} = complex_def_returning_array[2]
        
        indexed_alias;
        indexed_alias.child;
        indexed_alias_to_table["c"];
        indexed_alias_to_table["d"][1];
        k1[] = indexed_alias_to_table_2.keys
        k1[0];
        k2[] = ia_2_to_table_2.keys 
        k2[1];
        k3[] = ia_3_to_table_2.keys
        k3[2];
    }

iat {=
        ia_target {
            child [/ B /]
            [/ A /]  
        }
               
        ia_array[] = [ ia_target, ia_table, ia_table_2, "X" ]
        ia_array_2[] = [ "X", "D" ]
        
        ia_table{} = { "c": "C", "d": ia_array_2 }
        ia_table_2{} = { "E": "x", "F": "x", "G": "x" }
        
        ia_array_type[] = []
        ia_array_type complex_def_returning_array {
            if (1) {
                ia_array;
            }
        }
        ia_array_type alias_to_array = ia_array
        ia_2_to_table_2{} = alias_to_array[2]
        ia_3_to_table_2{} = complex_def_returning_array[2]

        k2[] = ia_2_to_table_2.keys 
        k2[1];
        k3[] = ia_3_to_table_2.keys
        k3[2];
=}    

    
    public test_case aliased_array_test {
        int category = instantiations
        name = "Aliased Array Test"
        key = "aliased_array"

        expected = "ABCDEF"

        a[] = [ "A", "B" ]
        c[] = [ "C", "D" ]
        e[] = [ "E", "F" ]
    
        aa = a
        cc = c
        ee = e
 
        cccc {
            ccc = cc    
        }

        eeee {
            eee = ee
        }

        eeeee = eeee.eee 

        aa[0];
        aa[1];
        cccc.ccc[0];
        cccc.ccc[1];
        eeeee[0];
        eeeee[1];
    }


    public test_case parameter_test {
        int category = parameters
        name = "Parameter Test"
        key = "param"

        expected = "ABCDEFGHIJKLMNOPQ"

        dynamic simple_param(a) {
            a;
        }

        d_param = "D"
        l_param = "L"
        n_param = "N"

        dynamic multiple_params(b, c, d) {
            b;
            c;
            d;
        }

        gtype [/]
        gtype g_param [/ G /]

        dynamic typed_params(int e, char f, gtype g) {
            if (e == 5) [/ E /]
            f;
            g;
        }

        param_parent {
            child = "H"
        }

        param_parent h_param [/]

        dynamic param_child(param_parent p) {
            p.child;
        }

        dynamic p_with_p(i) {
            if (i == "III") [/ I /]
            else [/ x /]
        }

        iii = "III"

        param_with_param {
            simple_param(p_with_p(iii));
        }

        p_2("J", [/ K /]) param_in_super [/]

        p_2(*) any_param_in_super(a, b) [/]
        
        param_in_definition = p_2(n_param, [``O``])

        p_2(p1, p2) {
            param_1 = p1
            param_2 {
                p2;
            }
        }

        parent_of_child {
            child(z) = z
        }

        child_with_param(x) {
            parent_of_child.child(x);
        }

        parent_with_param(y) {
            child = y
        }
        
        simple_param("A");
        multiple_params([/ B /], [``C``], d_param);
        typed_params(5, 'F', g_param);
        param_child(h_param);
        param_with_param;
        param_in_super.param_1;
        param_in_super.param_2;
        any_param_in_super(l_param, "x").param_1;
        any_param_in_super("x", "M").param_2;
        param_in_definition.param_1;
        param_in_definition.param_2;
        child_with_param('P');
        parent_with_param("Q").child;
    }

pt {=
        l_param = "L"
        p_2(p1, p2) {
            param_1 = p1
            param_2 {
                p2;
            }
        }
        p_2(*) any_param_in_super(a, b) [/]

        any_param_in_super(l_param, "x").param_1;
        any_param_in_super("x", "M").param_2;
=}


    public test_case loop_parameter_test {
        int category = parameters
        name = "Loop Parameter Test"
        key = "loop_param"

        expected = "ABCDEFGHIJKL"

        dynamic foo(a) {
            x = a
        }

        dynamic bar(foo f) {
            f.x;
        }

        dynamic baz(z) {
            z;
        }

        bam {
            dynamic boo(x) = x
        }

        foo[] de = [ foo("D"), foo("E") ]
        foo[] fg = [ foo("F"), foo("G") ]
        char[] hi = [ 'H', 'I' ]
        jk[] = [ 'J', 'K' ]
        
        array_holder(a[]) {
            aa[] = a
        }

        tp {
            int nr = 0
            char ap[] = [ for int n from 0 to nr { 'L' } ]
        }

        tp[] tps = [ tp1 ]
        
        tp tp1 {
            int nr = 1
        }
        
        for char c from 'A' through 'C' {
            c;
        }
        for foo f: de {
            bar(f);
        }
        for foo f: fg {
            baz(f.x);
        }
        for char c: hi {
            bam.boo(c);
        }
        for x: array_holder(jk).aa {
            x;
        }
        for char p: tps[0].ap {
            p;
        }
    }

lpt {=
        dynamic foo(a) {
            x = a
        }

        dynamic bar(foo f) {
            f.x;
        }
        foo[] de = [ foo("D"), foo("E") ]
        for foo f: de {
            bar(f);
        }
=}

    public test_case nested_parameter_test {
        int category = parameters
        name = "Nested Parameter Test"
        key = "nested_param"

        expected = "ABCDEFGHI"

        dynamic nested_1(x) = x
        dynamic nested_2(y) = y
        dynamic nested_3(z) = z

        nested_caller(a) = nested_1(nested_2(nested_3(a)))

        nested_parent {
            nested_deep(x) = x
            nested_mid(y) = y
            nested_top(z) = nested_mid(nested_deep(z))
         }
         
        nested_parent subclassed_nested_parent [/]
        aliased_nested_parent = nested_parent;

        parent_param {
            child [/ F /]
        }

        parent_param_container(parent_param pp) {
           parent_param aliased_parent_param = pp
        }

        show_param_child(parent_param_container ppc) {
            parent_param p_p = ppc.aliased_parent_param
            
            show(parent_param p) {
                p.child;
            }
            
            show(p_p);
        }

        apc {
            g [/ x /]
            h [/ x /]
            i [/ x /]
        }
        
        ap(apc aa) {
            apc pc = aa
        }
        
        apc p {
            g [/ G /]
            h [/ H /]
            i [/ I /]
        }
        
        tp(ap pp) {
            apc ppc = pp.pc
            
            vw(apc pac) {
                pac.i;    
            }       
            
            pp.pc.g;
            ppc.h;
            vw(pp.pc);
        }
        
        
        nested_1(nested_2(nested_3("A")));
        nested_caller("B");
        nested_parent.nested_top("C");
        subclassed_nested_parent.nested_top("D");
        aliased_nested_parent.nested_top("E");
        show_param_child(parent_param_container(parent_param));
        tp(ap(p));        
    }

npt {=
        parent_param {
            child [/ F /]
        }

        parent_param_container(parent_param pp) {
           parent_param aliased_parent_param = pp
        }

        show_param_child(parent_param_container ppc) {
            parent_param p_p = ppc.aliased_parent_param
            
            show(parent_param p) {
                p.child;
            }
            
           show(p_p);
        }
        show_param_child(parent_param_container(parent_param));
=}

tpt {=

        apc {
            g [/ x /]
            h [/ x /]
            i [/ x /]
        }
        
        ap(apc aa) {
            apc pc = aa
        }
        
        apc p {
            g [/ G /]
            h [/ H /]
            i [/ I /]
        }
        
        tp(ap pp) {
            apc ppc = pp.pc
            
            vw(apc pac) {
                pac.i;    
            }       
            
            
           /--- pp.pc.g; --/
            ppc.h;
            vw(pp.pc);
        }

        tp(ap(p));        
=}

    public test_case parameter_child_array_test {
        int category = parameters
        name = "Parameter Child Array Test"
        key = "parameter_child_array"

        expected = "ABCD"

        geo [/]
        neo [/]
        
        geo geosub(w) {
            ww = w
        }
        
        geosub("C") geosub_c [/]
        neosub("D") neosub_d [/]
        
        neo neosub(y) {
            yy = y
        }
        
        mesh(geo ge, neo ne) {
            neo n = ne
            arry[] = [ ge.ww, n.yy ]
    
            arry[0];
            arry[1];
            
        }
        
        mesh(geosub("A"), neosub("B")) meshsub_ab [/]
        mesh(geosub_c, neosub_d) meshsub_cd [/]
        
        meshsub_ab;
        meshsub_cd;
    }


    public test_case parameter_as_child_test {
        int category = parameters
        name = "Parameter as Child Test"
        key = "param_as_child"
        
        expected = "ABCD"
        
        param_parent(int a, b, c, d) [/]
        
        string_c = "C"
        string_d = "D"
        string_x = "X"
        
        param_parent(0, "X", string_x, string_d) pp_1 [/]
        
        if (param_parent(1, string_x, string_x, string_x).a == 1) [/ A /]
        else [/ X /]
        param_parent(0, "B", string_x, string_x).b;
        param_parent(0, "X", string_c, string_x).c;
   /--     pp_1.d; --/
    }


    public test_case array_test {
        int category = collections
        name = "Array Test"
        key = "array"

        expected = "ABCDEFGHIJKLMN"

        fixed_array[3] = [ "A", "B", "C" ]

        dynamic_array[] = [ for int i from 0 to 3 {
                                if (i == 0) { "D" }
                                else if (i == 1) { "E" }
                                else { "F" }
                            }
                          ]

        growable_array[] = [ "G" ]

        child {
            item_h = "H"
            item_j = "J"

            growable_array[0] = item_h
            growable_array[1] = "I"
            growable_array[2] = item_j

            for z in growable_array {
                z;
            }
        }
        
        index_calc_array[3] = [ "K", "L", "M" ]

        super_array[] = []
        super_array sub_array = [ "N" ]
                
        for w in fixed_array {
            w;
        }
        for x in dynamic_array {
            x;
        }
        for y in growable_array {
            y;
        }
        child;

        int n = 1
        index_calc_array[n - 1];
        index_calc_array[n];
        index_calc_array[index_calc_array.count - n];
        sub_array[0];
    }


    public test_case multidimensional_array_test {
        int category = collections
        name = "Multidimensional Array Test"
        key = "multidim_array"

        expected = "ABCDEFGHI"

        x[][] = [ ["A", "B"], ["C"] ]

        y[1][2][3] = [ [ ["D", "F", "H"], ["E", "G", "I"] ] ]

        for xx in x {
            for z in xx {
                z;
            }
        }

        for int i from 0 to 3 {
            for int j from 0 to 2 {
                y[0][j][i];
             }
        }
    }


    public test_case array_parameter_test {
        int category = collections
        name = "Array Parameter Test"
        key = "array_param"

        expected = "ABCDEFGHIJKL"

        x[3] = [ "A", "B", "C" ]
        y[2][3] = [ ["D", "E", "F"], ["G", "H", "I"] ]
        z[1] = [ "L" ]

        dynamic show(aa) {
            for a in aa {
                if (a.count > 1) {
                    show(a);
                } else {
                    a;
                }
            }
        }

        dynamic show_j(x) {
            z[] = [ x ]
            xx(a) = a

            z[0];
        }

        dynamic show_j("K") show_k [/]

        dynamic show_l(x) {= x; =}

        show(x);
        show(y);
        show_j("J");
        show_k;
        show_l(z[0]);

    }


    public test_case array_builder_test {
        int category = collections
        name = "Array Builder Test"
        key = "array_builder"

        expected = "ABCDEFGHIJKLMNOP"

        dynamic xy(xx, yy) {
            x = xx
            y = yy
        }

        init_vals_1[][] = [ ["A", "B"], ["C", "D"] ]
        init_vals_2[][] = [ ["E", "F"], ["G", "H"] ]
        init_vals_3[][] = [ ["I", "J"], ["K", "L"] ]
        init_vals_4[][] = [ ["M", "N"], ["O", "P"] ]

        dynamic xy(vals[0], vals[1]) xy_from(vals[]) [/]

        xy[] xy_array_builder_1 = [ xy(init_vals_1[0][0], init_vals_1[0][1]),  xy(init_vals_1[1][0], init_vals_1[1][1]) ]
        xy[] xy_array_builder_2(val_matrix[][]) = [ xy(val_matrix[0][0], val_matrix[0][1]),  xy(val_matrix[1][0], val_matrix[1][1]) ]
        xy[] xy_array_builder_3(val_matrix[][]) = [ for v in val_matrix { xy(v[0], v[1]) } ]
        xy[] xy_array_builder_4(val_matrix[][]) = [ for v in val_matrix { xy_from(v) } ]


        for xy aa in xy_array_builder_1 {
            aa.x;
            aa.y;
        }
        for xy bb in xy_array_builder_2(init_vals_2) {
            bb.x;
            bb.y;
        }
        for xy cc in xy_array_builder_3(init_vals_3) {
            cc.x;
            cc.y;
        }
        for xy dd in xy_array_builder_4(init_vals_4) {
            dd.x;
            dd.y;
        }
    }

abt {=
 dynamic xy(xx, yy) {=
    x = xx
    y = yy
 =}
 init_vals_2[][] = [ ["E", "F"], ["G", "H"] ]
 xy[] xy_array_builder_2(val_matrix[][]) = [ xy(val_matrix[0][0], val_matrix[0][1]),  xy(val_matrix[1][0], val_matrix[1][1]) ]
 for xy bb in xy_array_builder_2(init_vals_2) {=
    bb.x;
    bb.y;
 =}
=}

    public test_case array_element_builder_test {
        int category = collections
        name = "Array Element Builder Test"
        key = "array_element_builder"

        expected = "ABCDEFGHIJKLMN"

        xy(xx, yy) {
            x = xx
            y = yy
        }

        xy[2] xy_array_1 = [ xy("A", "B"), xy([/ C /], [``D``]) ]

        xy ef {
            x = "E"
            y = "F"
        }


        xy[] xy_array_2 = [ ef ]

        xy("G", "H") gh [/ x /]

        xy[] xy_array_3 = [ gh ]

        xy(p, q) ij(p, q) [/ x /]
        xy(p, q) kl(p, q) [/ x /]

        xy[] xy_array_4(i, j, k, l) = [ ij(i, j), kl(k, l) ]

        xy(a, b) mn(a, b) [/ x /]
        xy[] xy_5(p1, p2) = [ mn(p1, p2) ]
        show_array_5(m, n) {

            xy[] xy_array_5 = xy_5(m, n)

            for xy e in xy_array_5 {
                e.x;
                e.y;
            }
        }

       for xy a in xy_array_1 {
            a.x;
            a.y;
        }
        for xy b in xy_array_2 {
            b.x;
            b.y;
        }
        for xy c in xy_array_3 {
            c.x;
            c.y;
        }
        for xy d in xy_array_4("I", "J", "K", "L") {
            d.x;
            d.y;
        }
        show_array_5("M", "N");
    }


    public test_case complex_array_test {
        int category = collections
        name = "Complex Array Test"
        key = "complex_array"

        expected = "ABCDEF"

        foo {
            x [?]
            
            "[";
            x;
            "]";
        }

        dynamic show_foo(foo f) {
            f.x;
        }

        foo_set(char c) {
            foo[] ff = []

            c;
            for int i from 0 to ff.count {
                show_foo(ff[i]);
            }
        }

        foo_set[] foo_sets = [ foo_1, foo_2 ]

        foo_set('A') foo_1 {
            foo[] ff = [ foo_B, foo_C ]

            foo foo_B {
                x = "B"
            }

            foo foo_C {
                x = "C"
            }
        }

        foo_set('D') foo_2 {
            foo[] ff = [ foo_E, foo_F ]

            foo foo_E {
                x = "E"
            }

            foo foo_F {
                x = "F"
            }
        }

        for foo_set fs in foo_sets {
            fs;
        }
    }


    public test_case array_element_type_test {
        int category = collections
        name = "Array Element Type Test"
        key = "array_element_type"

        expected = "ABCDEFGHIJK"

        fum(xx) {
            x = xx

            x;
        }

        fum("A") fum_a [/]

        fum("x") fum_b {
            x = "B"
        }

        fum("x") fum_c {
            [/ C /]
        }

        fum("x") fum_y(y) {
            x = y;
        }
        fum_y("D") fum_d [/]

        fum(z) fum_fum(z) [/]
        fum_fum("E") fum_e [/]
        fum_fum("x") fum_f {
            "F";
        }

        fum("G") fum_gg [/]
        fum(fum_gg.x) fum_g [/]

        fum("I") fum_i [/]
        fum("J") fum_j [/]
        fum("K") fum_k [/]

        fum[] fum_array_1 = [ fum_a, fum_b, fum_c, fum_d, fum_e, fum_f, fum_g, fum_fum("H") ]
        fum[] fum_array_2 = [ fum_i, fum_j, fum_k ]
        dynamic show_fum(fum f),(z) {
            with (f) {
                f;
            } else {
                "x";
            }
        }

        for fum f in fum_array_1 {
            f;
        }

        fum_array_2[0];
        fum_array_2[1].x;
        
        show_fum(fum_array_2[2]);
    }

aet {=
fum(xx) {=
    x = xx

    x;
=}


fum("G") fum_gg [/]
fum(fum_gg.x) fum_g [/]

fum_g;

=}

    public test_case array_element_child_array_test {
        int category = collections
        name = "Array Element Child Array Test"
        key = "array_element_child_array"

        expected = "ABCDEFG"
        
        fum [/]

        fo {
            fum[] fofum = []
        }

        fo fo1 {
            fum[] fofum = [ "A", "B" ]
        }
		
        fo fo2 {
            fum[] fofum = [ "C", "D" ]
        }

		fo fo3 {
            fum[] fofum = [ "E", "F" ]
        }

        fo fo4 {
            fum[] fofum = [ "G" ]
        }

        fo[] fos = [ fo2, fo3 ] 
		
        sho_fo(fo f),(x) {
            with (f) {
                for int iii from 0 to 2 {
                    f.fofum[iii];
                }
            } else {
                "xxx";
            } 
        }

        sho_fum(fum fm),(x) {
            with (fm) {
                fm;
            } else {
                "z";
            } 
        }

		sho_fo(fo1);

		for fo ff in fos {
		    for int ii from 0 to 2 {
		    	ff.fofum[ii];
		    }
        }
        
        sho_fum(fo4.fofum[0]);
	}		

aecat {=
        fum [/]

        fo {
            fum[] fofum = []
        }

        fo fo2 {
            fum[] fofum = [ "C", "D" ]
        }

        fo fo3 {
            fum[] fofum = [ "E", "F" ]
        }

        fo[] fos = [ fo2, fo3 ] 
        
        for fo ff in fos {
            for int ii from 0 to 2 {
                ff.fofum[ii];
            }
        }
=}

	
	public test_case dynamic_array_test {
        int category = collections
        name = "Dynamic Array Test"
        key = "dynamic_array"
	
	    expected = "ABCDEFGHIJKLMNOPQRST" 
	
	    boolean true_flag = true
	    boolean false_flag = false
	    
	    d = "D"
	    e = "E"
	    g = "G"
	    x = "x"
	    
	    hi[] = [ "H", "I" ]
        jk[] = [ "J", "K" ]
        dynamic lm(n) {
            if (n == 1)      [/ L /]
            else if (n == 2) [/ M /]
            else             [/ x /]
        }
	    
	    nested_dynamic_array[] = [ for c in jk { c } ] 
        nested_array_with_loop_param[] = [ for i from 1 to 3 { lm(i) } ]
        
        no[] = [ "x", "N", "O" ]
        nested_array_with_loop_index[] = [ for i from 1 to 3 { no[i] } ]
        
        pq[] = [ "x", "P", "x", "Q" ]
        nested_array_with_expression_index[] = [ for i from 0 to 2 { pq[(2 * i + 1)] } ]

        rs[] = [ for i from 0 to 2 { if (i == 0) { "R" } else { "S" } } ]
        
        nested_array_with_dynamic_array_reference[] = [ for i from 0 to 2 {= rs[i] =} ]

        tt[] = [ "T" ]
        super_array[] = []
        
        super_array dimless_dynamic_array = [ for t in tt {= t =} ]
	    
	    dynamic_array[] = [ 
	                        if (true_flag)  { [/ A /] },

	                        if (false_flag) { [/ x /] },

	                        if (true_flag)  { [/ B /] }
	                                  else  { [/ x /] },

                            if (false_flag) {= [/ x /] =}
                                       else {= [/ C /] =},
                                       
                            if (true_flag)  { if (true_flag) {= d =} },

                            if (true_flag)  {= if (false_flag) { x } =},

                            if (true_flag)  {= {= e; [/ F /] g; =} =},
                           
                            for hh in hi { hh },
                            for jj in nested_dynamic_array { jj },
                            for ll in nested_array_with_loop_param {= ll =},
                            for nn in nested_array_with_loop_index {= nn =},
                            for pp in nested_array_with_expression_index {= pp =},
                            for rr in nested_array_with_dynamic_array_reference {= rr =}
                          ]

        for el in dynamic_array {
            el;
        }
        for ell in dimless_dynamic_array {
            ell;
        }
    }

    public test_case dynamic_array_element_child_test {
        int category = collections
        name = "Dynamic Array Element Child Test"
        key = "dynamic_array_element_child"
    
        expected = "ABCDEF" 

        obj {
            a = "A"
            b = "x"
            c = "x"
            d = "x"
            e = "x"
            f = "x"
        }
    
        obj sub_obj {
            b = "B"
        }
        
        obj sub_obj_with_arg(z) {
            c = z
        }
        
        arg {
            dd = "D"
            ee = "z"
            ff = "z"
        }
        
        arg arg_with_arg(y) {
            ee = y
        }
        
        arg sub_arg {
            ff = "F"
        }
        
        obj sub_obj_with_arg_with_arg(arg aa) { 
            d = aa.dd
            e = aa.ee
        }
        
        obj sub_obj_with_local_sub {
            arg aa = sub_arg
            f = aa.ff;
        }
        
        dynamic item_for_index(obj[] obs, int ix) {
            obj o = obs[ix]
            
            if (ix == 0) {
                o.a;
            } else if (ix == 1) {
                o.b;
            } else if (ix == 2) {
                o.c;
            } else if (ix == 3) {
                o.d;
            } else if (ix == 4) {
                o.e;
            } else if (ix == 5) {
                o.f;
            } else {
                "y";
            }
        } 
        
        obj[] objs = [ obj,
                       sub_obj, 
                       sub_obj_with_arg("C"),
                       sub_obj_with_arg_with_arg(arg),
                       sub_obj_with_arg_with_arg(arg_with_arg("E")),
                       sub_obj_with_local_sub
                     ]
    
        items[] = [ for int i from 0 to 6 {=
                           item_for_index(objs, i),
                       =}
                  ]
                  
        for item in items {
            item;
        }
    }

    public test_case recursive_dynamic_array_test {    
        int category = collections
        name = "Recursive Dynamic Array Test"
        key = "recursive_dynamic_array"
    
        expected = "ABCDE" 

        base_obj {
            base_obj[] child_objs = []
            
            dynamic base_obj[] all_desc_objs = [
                    for base_obj bo in child_objs {=
                        bo,
                        for base_obj bbo in bo.all_desc_objs {=
                           bbo
                        =}
                    =}
                ]

            type;
        }
        
        base_obj A [/]
        base_obj B {
            base_obj[] child_objs = [ C, D ]
        }
        base_obj C [/]
        base_obj D [/]
        base_obj E [/]
        base_obj mom {
            base_obj[] child_objs = [ A, B, E ]
        }
        
        for base_obj o in mom.all_desc_objs {
            o;
        }
    }

    public test_case dynamic_table_test {
        int category = collections
        name = "Dynamic Table Test"
        key = "dynamic_table"
    
        expected = "ABCDEFGHI" 

        key_array[] = [ "a", "b" ]
        value_array[] = [ "A", "B" ]
        
        nested_table{} = { c: "C", d: "D" } 
       
        boolean tru = true
        boolean fals = false

        dynamic ghval(boolean g) {
            if (g) [/ G /]
            else   [/ H /]
        }
        
        hkey = "h"

        ii [/]
        ii iia(z) {
            z;
        }
        ii iiq = iia("I")
        ii[] ii_array = [ iiq ]
    
        dynamic_table{} = {
            
            for int i from 0 to 2 {=
                key_array[i]: value_array[i]
            =},
            
            for k in nested_table.keys {=
                k: nested_table[k]
            =},
            
            if (tru) {=
                "e": "E"
            =},
            
            if (fals) {=
               "f": "x"
            =} else {=
               "f": "F"
            =},
            
            {= "g": ghval(tru) =},
            
            {= hkey: ghval(fals) =},

            for ii iii in ii_array {=
                "i": iii
            =}
        }
        
        dynamic_table["a"];
        dynamic_table["b"];
        dynamic_table["c"];
        dynamic_table["d"];
        dynamic_table["e"];
        dynamic_table["f"];
        dynamic_table["g"];
        dynamic_table["h"];
        dynamic_table["i"];
    }        

    public test_case table_element_type_test {
        int category = collections
        name = "Table Element Type Test"
        key = "table_element_type"

        expected = "ABCDEFGHIJKLM"

        gum(xx) {
            x = xx

            x;
        }

        gum("A") gum_a [/]

        gum("x") gum_b {
            x = "B"
        }

        gum("x") gum_c {
            [/ C /]
        }

        gum("x") gum_y(y) {
            x = y;
        }
        gum_y("D") gum_d [/]

        gum(z) gum_gum(z) [/]
        gum_gum("E") gum_e [/]
        gum_gum("x") gum_f {
            x = "F"
        }

        gum("G") gum_gg [/]
        gum(gum_gg.x) gum_g [/]

        gum("8") gum_h_index [/]
        gum("H") gum_h [/]

        gum("J") gum_j [/]
        gum("K") gum_k [/]
        gum("M") gum_m [/]

        gum{} gum_table_1 = { "3": gum_c, "4": gum_d,
                              "1": gum_a, "2": gum_b,
                              five: gum_e, six: gum_f,
                              seven: gum_g, gum_h_index.x: gum_h,
                              "9": gum_gum("I"),
                              (ten): gum_m  }
        gum{} gum_table_2 = { "j": gum_j, "k": gum_k }
        
        gum{} gum_table_3 = { "x": gum("L") } 

        fv = "five"
        six [/]
        ten = "10"
        
        
        for int n from 1 through 6 {
            gum_table_1[n];
        }
        
        gum_table_1[fv];
        gum_table_1[six.type];
        gum_table_1["seven"];
        gum_table_1["gum_h_index.x"];
        gum_table_1["9"];
        

        gum_table_2["j"];
        gum_table_2["k"].x;
        
        for gum g in gum_table_3 {
            g.x;
        }
        
        gum_table_1["10"];
    }

te {=
   gum{} = { yo: "ho" }
   
   yo [/]
   
   gum[yo.type];
=}

    public test_case table_test {
        int category = collections
        name = "Table Test"
        key = "table"

        expected = "ABCDEFGHIJKLMNO"

        item_b = "B"
        key_c = "item_c"
        key_f = "item_f"
        key_g = "item_g"
        item_f = "F"

        fixed_table{} = { "": "D", "item_a": "A", "item_b": item_b, "item_c": "C" }
        dynamic_table{} = { for int i from 0 to 3 {=
                                if (i == 0)      {= "item_e": "E"    =}
                                else if (i == 1) {= "item_f": item_f =}
                                else             {=    key_g: "G"    =}
                             =}
                           }
                          
        /--- children of elements in a typed table ---/
        key_hi = "item_hi"

        table_item(a, b) {
            subitem_1 = a
            subitem_2 = b
        }
          
        table_item typed_table{} = { "": "x", "item_hi": table_item("H", "I") }
        tbl{} = { "a": "" }
        
        table_with_params(l, m){} = { l: "L", "m": m }
        table_with_arg(n){} = { "n": n }
        
        tbl2{} = table_with_params("l", "M");
        
        table_super{} = {}
        table_super table_sub = { "o": "O" }
        
        fixed_table["item_a"];
        fixed_table["item_b"];
        fixed_table[key_c];
        fixed_table[""];
        dynamic_table["item_e"];
        dynamic_table[key_f];
        dynamic_table["item_g"];
        typed_table[key_hi].subitem_1;
        typed_table[key_hi].subitem_2;

        with (tbl["a"]) {
            "J";
        }
        if (tbl["a"]) {
            "x";
        }
        with (tbl["b"]) {
            "X";
        } else {
            "K";
        }
        if (tbl["b"]) {
            "x";
        }

        tbl2["l"];
        tbl2["m"];
        table_with_arg("N")["n"];
        table_sub["o"];
    }

tt {=
  table_with_arg(n){} = { "n": n }
  table_with_arg("N")["n"];
=}    


    public test_case table_parameter_test {
        int category = collections
        name = "Table Parameter Test"
        key = "table_param"

        expected = "ABCDEFGHIJ"

        x{} = { "a":"A", "b":"B" }
        y{} = { "c":"C", "d":"D" }
        z{}{} = { "t1":{ "e":"E", "f":"F"}, "t2":{ "g":"G", "h":"H" } }
 
        foo(x) {
           i [/ I /]
           j = x
        } 

        foo foos{} = { "foo_i": foo, "foo_j":foo("J") }        
        show_foo_ij(f{}) {
           f["foo_i"].i;
           f["foo_j"].j;
        } 

        show_ab(bb[], p, q) {
            bb[p];
            bb[q];
        } 
        
        dynamic show(aa) {
            for k in aa.keys {
                if (aa[k].count > 1) {
                    show(aa[k]);
                } else {
                    aa[k];
                }
            }
        }

        show_ab(x, "a", "b");
        show(y);
        show(z);
        show_foo_ij(foos);
    }

public tblpt {=
        z{}{} = { "t1":{ "e":"E", "f":"F"}, "t2":{ "g":"G", "h":"H" } }
        dynamic show(aa) {
          for k in aa.keys {
            if (aa[k].count > 1) {
                show(aa[k]);
            } else {
                aa[k];
            }
          }
        }
        show(z);
=}

    
    public test_case multidimensional_table_test {
        int category = collections
        name = "Multidimensional Table Test"
        key = "multidim_table"

        expected = "ABCDEFG"

        x{} = { "a":["A", "B"] }
       
        y[] =  [ {"c":"C"}, {"d":"D"} ]

        z{}{} = { "z1":{"e":"E", "f":"F"}, "z2":{"g":"G"} }

        for k in x.keys {
            for xx in x[k] {
                xx;
            }
        }

        for yy in y {
            for k in yy.keys {
                yy[k];
            }
        }

        for k in z.keys {
            for kk in z[k].keys {
                z[k][kk];
            }
        }
    }

public mtt {
  z{}{} = { "z1":{"e":"E", "f":"F"}, "z2":{"g":"G"} }
  for k in z.keys {
    for kk in z[k].keys {
      z[k][kk];
    }
  }
}


    public test_case mapped_array_table_test {
        int category = collections
        name = "Mapped Array Table Test"
        key = "mapped_array_table"
        
        expected = "ABCDEF"
        
        data_array[] = [ "A", "X", "B", "Y", "C", "D" ]
        mapped_array_table{} = data_array
        str_ix = "4"
        int int_ix = 5
        
        cache_array[] = [ "X", "X", "X" ]
        keep by ix0 in cache_array: val1(x) = x
        keep by ix1 in cache_array: val2(x) = x
        ix0 = "0"
        int ix1 = 1
        
        /-- the instantiations have to be dynamic because of the dynamic keeps --/
        eval(val1(: "E" :));
        eval(val2(: "F" :));
        
        mapped_array_table[0];
        mapped_array_table["2"];
        mapped_array_table[str_ix];
        mapped_array_table[int_ix];
        cache_array[0];
        cache_array[1];
    }


    public test_case collection_operators_test {
        int category = collections
        name = "Collection Operators Test"
        key = "collection_operators"

        expected = "ABCDEFGHIJKLMNOPQRS"
        
        a = "a"
        c = "c"
        X = "X"
        y = "y"
        Z = "Z"
        
        array_1[] = [ "a" ]
        array_2[] = [ "b", "c" ]
        array_3[] = array_1 + array_2
        copy_of_array_2[] = [ "b", "c" ]
        
        table_1{} = { "x": "X" } 
        table_2{} = { "y": "Y", "z": "Z" }
        copy_of_table_2{} = { "z": "Z", "y": "Y" } 
        
        
        if (a in array_1) [/ A /] else [/ x /]
        if (a in array_2) [/ x /] else [/ B /]
        if (c in array_3) [/ C /] else [/ x /]
        
        if (array_1.count == 1) [/ D /] else [/ x /]
        if (array_2.count == 2) [/ E /] else [/ x /]
        if (array_3.count == 3) [/ F /] else [/ x /]
        
        if (X in table_1) [/ G /] else [/ x /]
        if (y in table_2) [/ x /] else [/ H /]
        if (Z in table_2) [/ I /] else [/ x /]

        if (y in table_2.keys) [/ J /] else [/ x /]
        if (Z in table_2.keys) [/ x /] else [/ K /]
        
        if (table_1.count == 1) [/ L /] else [/ x /]
        if (table_2.count == 2) [/ M /] else [/ x /]
        
        if (array_2 == copy_of_array_2) [/ N /] else [/ x /]
        if (array_2 == array_1) [/ x /] else [/ O /]
        if (array_2 != array_1) [/ P /] else [/ x /]
        if (table_2 == copy_of_table_2) [/ Q /] else [/ x /]
        if (table_2 == table_1) [/ x /] else [/ R /]
        if (table_2 != table_1) [/ S /] else [/ x /]
        
    }
cop {=
  array_1[] = [ "a" ]
  array_2[] = [ "b", "c" ]
  array_3[] = array_1 + array_2
        a = "a"
        c = "c"
        if (a in array_1) [/ A /] else [/ x /]
        if (a in array_2) [/ x /] else [/ B /]
        if (c in array_3) [/ C /] else [/ x /]
  array_1.count;
  array_2.count;
  array_3.count;
=}

    public test_case count_test {
        int category = collections
        name = "Count Test"
        key = "count"

        expected = "ABCDEF"
        
        a = "a"
        b[] = [ "b1", "b2" ]
        c{} = { c1: "1", c2: "2", c3: "3" } 
        d[] = [ for int n from 0 to 4 {= ("d" + n) =} ]
        e[] = [ "e1", "e2", "e3", "e4", "e5" ]
        ealias = e
        f[] = [ "f1", "f2", "f3", "f4", "f5", "f6" ]
        f fsub [/]
        
        if (a.count == 1)      [/ A /] else [/ x /]
        if (b.count == 2)      [/ B /] else [/ x /]
        if (c.count == 3)      [/ C /] else [/ x /]
        if (d.count == 4)      [/ D /] else [/ x /]
        if (ealias.count == 5) [/ E /] else [/ x /]
        if (fsub.count == 6)   [/ F /] else [/ x /]
    }

    public test_case collection_parse_test {
        int category = collections
        name = "Collection Parse Test"
        key = "collection_parse"
        expected = "ABCDEFGH"

        coll_1_str = '[ "A", "B" ]'
        coll_2_str = '{ "c": "C", "d": "D" }'
        coll_3_str = '[ [ "E" ], { "f": "F" } ]'
        coll_4_str = '{ "gh": { "g": "G", "h": [ "H" ] } }' 

        coll_1[] = array.parse(coll_1_str)
        coll_2{} = table.parse(coll_2_str)
        coll_3[] = array.parse(coll_3_str)
        coll_4{} = table.parse(coll_4_str)
        
        coll_1[0];
        coll_1[1];
        coll_2["c"];
        coll_2["d"];
        coll_3[0][0];
        coll_3[1]["f"];
        coll_4["gh"]["g"];
        coll_4["gh"]["h"][0];           
    }

    public test_case collection_utilities_test {
        int category = utilities
        name = "Collection Utilities Test"
        key = "collection_utils"

        expected = "ABCDEFGHI"

        test_array[] = [ "A", "X" ]
       
        test_table{} = {"d": "D", "e": "X"}

        array.get(test_array, 0);
        array.set(test_array, 1, "B");
        test_array[1];
        if (array.size(test_array) == 2) [/ C /]
        else [/ X /]
 
        table.get(test_table, "d");
        table.set(test_table, "e", "E");
        test_table["e"];
        table.set(test_table, "f", "F");
        test_table["f"];
        if (table.size(test_table) == 3 && test_table.count == 3) [/ G /]
        else [/ X /]
        
        array.add(test_array, "I");
        if (array.size(test_array) == 3 && test_array.count == 3) [/ H /]
        else [/ X /]
        test_array[2];
    }

cu {=
    test_array[] = [ "A", "X" ]
    array.get(test_array, 0);
    array.set(test_array, 1, "B");
    test_array[1];
    if (array.size(test_array) == 2) [/ C /]
    else [/ X /]
=}

    public test_case object_child_test {
        int category = instantiations
        name = "Object Child Test"
        key = "object_child"

        expected = "ABCDEFGHIJK"

        obj {
            a [/ x /]
            b [/ x /]
            c [/ x /]
            d [/ x /]
            e [/ x /]
            f [/ x /]
            g(z) = z
            hi(y) = y

            this;
        }

        obj sub_1 {
            a [/ A /]
            b [/ B /]
            c [/ C /]
            d [/ D /]
            e [/ E /]
            f [/ F /]
        }

        dynamic obj sub_2 {
            sub_1;
        }

        dynamic obj sub_3 {
            if (true) {
                sub_1;
            }
        }

        dynamic obj sub_4 {
            eval(g(: "G" :));
            this;
        }

        dynamic obj sub_5 {
            eval(hi(: "H" :));
            this;
        }

        dynamic obj sub_6 {
            eval(hi(: "I" :));
            this;
        }

        obj sub_7 {
            keep: j(x) = x
            dynamic set_j {
                eval(j(: "J" :));
            }
            this;
        }

        obj cobj(obj o) = o

        parent_obj {
            keep: obj ccobj(obj o) = o

            dynamic set_ccobj(obj oo) {
                eval(ccobj(: oo :));
            }

            dynamic set_ccobj_j {
                ccobj.set_j;
            }

            set_ccobj(sub_5);            
        }
        
        obj sub_8 {
            keep: k(x) = x
            dynamic set_k {
                eval(k(: "K" :));
            }
            eval(k("x"));
            this;
        }

        sub_8 sub_8_obj [/]

        show_xk(sub_8 kobj) {
            kobj.k;
            kobj.set_k;
            kobj.k;
        }


        sub_1.a;
        eval(cobj(: sub_1 :));
        cobj.b;

        sub_2.c;   
        eval(cobj(: sub_2 :));
        cobj.d;

        sub_3.e;
        eval(cobj(: sub_3 :));
        cobj.f;

        eval(cobj(: sub_4 :));
        cobj.g;

        parent_obj;
        parent_obj.ccobj.hi;

        parent_obj.set_ccobj(sub_6);
        parent_obj.ccobj.hi;

        parent_obj.set_ccobj(sub_7);
        eval(sub_7.j("x"));
        parent_obj.set_ccobj_j;
        sub_7.j;
            
        eval(sub_8_obj);
        if (show_xk(sub_8_obj) == "xK") {
            "K";
        } else {
            show_xk;
        }        
    }

oct {=
    sub_8 {
        keep: k(x) = x
        dynamic set_k {
            eval(k(: "K" :));
        }
        eval(k("x"));
        this;
    }

    sub_8 sub_8_obj [/]

    show_xk(sub_8 kobj) {
        kobj.k;
        kobj.set_k;
        kobj.k;
    }
    eval(sub_8_obj);
    show_xk(sub_8_obj);
=}

oct9 {=
    sub_9(z) {
        keep: l(x) = x
        dynamic set_l {
            eval(l(: z :));
        }
        eval(l("x"));
        this;
    }

  sub_9 lobj = sub_9("L");
  eval(lobj);
  test_cons(lobj);
         
  dynamic test_cons(sub_9 gm) {=
    gm.set_l;
    gm.l;
  =}

=}
    cocotest {
    
        cobj(g) {
           keep: co_co = g
           this;
        }
        
        parent_obj {
            cobj child_obj(cobj xx) = xx
            
            dynamic set_child_obj(cobj z) {
                eval(child_obj(: z :));
            }
        }
        
        parent_obj po {
            set_child_obj(cobj("G"));
        }

        log("constructing po");
        eval(po);
        log("constructing co_co");
        po.child_obj.co_co;
    }

    public test_case serialization_test {
        int category = utilities
        name = "Serialization Test"
        key = "serialization"

        expected = "ABCDEFGH"
        
        keep: serializable obj1 {
            keep: a = "A"
            keep: bc[] = [ "B", "C" ]
            keep: de{} = { "d": "D", "e": "E"  }
            keep: serializable fg {
                keep: f = "F"
                keep: g = "G"
            }
        }
             
        keep: serializable(str) obj2(str) {
            keep: a [/]
            keep: bc[] = []
            keep: de{} = {}
            keep: serializable(s) fg(s) {
                keep: f [/]
                keep: g [/]
            }            
        }

        obj3_nms[] = [ "h" ]
        obj3_vals[] = [ "H" ]
        
        keep: serializable(nms, vals) obj3(nms[], vals[]) {
            keep: h [/]
        }  

        obj2(obj1.serialize);

        obj2.a;
        obj2.bc[0];
        obj2.bc[1];
        obj2.de["d"];
        obj2.de["e"];
        obj2.fg.f;
        obj2.fg.g;
        
        obj3(obj3_nms, obj3_vals);
        
        obj3.h;
    }

st {=
        keep: serializable obj1 {
            keep: a = "A"
            keep: bc[] = [ "B", "C" ]
            keep: de{} = { "d": "D", "e": "E"  }
            keep: serializable fg {
                keep: f = "F"
                keep: g = "G"
            }
        }
             
        keep: serializable(str) obj2(str) {
            keep: a [/]
            keep: bc[] = []
            keep: de{} = {}
            keep: serializable(s) fg(s) {
                keep: f [/]
                keep: g [/]
            }            
        }

    obj3_nms[] = [ "h" ]
    obj3_vals[] = [ "H" ]
    
    keep: serializable(nms, vals) obj3(nms[], vals[]) {
        keep: h [/]
    } 
    
    obj1.serialize;
    
    obj3(obj3_nms, obj3_vals);
    
    obj3.h;
=}  
  

st2 {=
        serializable oa {
            keep:
            a = "A"
        }
        
        serializable od {
            keep:
            dd{} = { d: "D" }
        }
        
        serializable ob {
            keep:
            b[] = [ "B" ]
        }

        serializable of {
            keep:
            serializable(s) f(s) {
                keep:
                ff = "F"
            }            
        }

        dynamic show(z) {
            z;
            br;
        } 

        ob.serialize;
        show(oa.serialize);
        show(ob.serialize);
        show(od.serialize);
        show(of.serialize); 
             
        keep: serializable(str) o2(str) {
            keep:
            serializable(s) fg(s) {
                keep:
                f [/]
            }            
        }

        o2("{ fg.keep: { f: \"F\" } }");

        o2.fg.f;
=}

    public test_case sort_test {
        int category = utilities
        name = "Sort Test"
        key = "sort"

        expected = "ABCDEF"
        
        unsorted_array[] = [ "X", "C", "B", "A" ]
        sorted_unsorted_array[] = sorted_array(unsorted_array)
        
        unsorted_table{} = { "c": "F", "b": "E", "a": "D" }
        sorted_unsorted_table{} = sorted_table(unsorted_table)

        {        
            for int i from 0 to 3 by 1 {
                sorted_unsorted_array[i];
            }
        
            for x in sorted_unsorted_table {
                x;
            }

        } catch {
            "!";
        }
        
    }
srt {=
        unsorted_table{} = { "c": "F", "b": "E", "a": "D" }
        sorted_unsorted_table{} = sorted_table(unsorted_table)
            for x in sorted_unsorted_table {
                x;
            }
=}

    public test_case external_test {
        int category = external_objects
        name = "External Object Test"
        key = "external"

        expected = "ABCDEFGHIJKLMNOPQR"

        external_interface {
            g [?]
            h [?]
            i [?]
            j [/]
            k = "x"
            r = "x"
            show(x) [?]
        }

        external_interface external_builder = org.fundev.test.ExternalTest("H")
        external_interface parameterized_builder(x) = org.fundev.test.ExternalTest(x)
        parameterized_builder("J") pb_sub [/]
        external_builder external_builder_subclass {
            show_k = k
        }
        internal_parent {
            show(x) = x
        }

        internal_caller(y) {
            internal_parent.show(y);
        }
        m = "M"
        external_interface external_parent = org.fundev.test.ExternalTest
        external_caller(z) {
            external_parent.show(z);
        }
        n = "N"
        aliased_method(w) = org.fundev.test.ExternalTest.other(w)
        
        q = "Q"
        fun_context my_context = this_domain.context

        external_interface external_alias(a) = org.fundev.test.ExternalTest(a);
        external_alias("R") external_sub {
            rr = r
        }

        org.fundev.test.ExternalTest.a;
        org.fundev.test.ExternalTest.b;
        org.fundev.test.ExternalTest.c;
        org.fundev.test.ExternalTest.d;
        org.fundev.test.ExternalTest("E").e;
        org.fundev.test.ExternalTest("F");
        external_builder.g;
        external_builder.h; 
        parameterized_builder("I").i;
        pb_sub.j; 
        external_builder_subclass.show_k;
        org.fundev.test.ExternalTest.show("L");
        internal_caller(m);
        external_caller(n);
        org.fundev.test.ExternalTest.other("O").methodZ;
        aliased_method("P").methodZ;
        my_context.construct("external_test.q");
        external_sub.rr;
    }

qtst {=
    q = "Q"
    fun_context my_context = this_domain.context
    my_context.construct("q");
=}

itst {=
    external_interface {
        i [?]
        show(x) [?]
    }
    external_interface parameterized_builder(x) = org.fundev.test.ExternalTest(x)
    parameterized_builder("I").i;
=}

rtst {
    external_interface {
        r [/ x /]
        show(x) [?]
    }

    external_interface external_alias(a) = org.fundev.test.ExternalTest(a);

    
    external_alias("R") external_sub {
        rr = r
    }
    
    external_sub.rr;
}
    
    public test_case cached_external_object_test {
        int category = external_objects
        name = "Cached External Object Test"
        key = "cached_external"

        expected = "ABCDEFGHIJ"

        external_obj {
            other [&]
        }
        external_obj aliased_obj(v) = org.fundev.test.ExternalTest(v)            
        aliased_method(w) = aliased_obj.other(: w :)
        identity_obj(o) = o

        eval(aliased_obj("A"));
        aliased_obj;
        eval(aliased_obj(: "B" :));
        aliased_obj;
        eval(aliased_obj(: "C" :));
        aliased_obj.show_value;
        eval(aliased_obj(: :));  // null constructor is "D"
        aliased_obj.d;
        
        eval(identity_obj(aliased_obj(: "E" :)));
        identity_obj.e;

        eval(aliased_obj(: "F" :));
        eval(identity_obj(: aliased_obj :));
        identity_obj.f;
       
        eval(aliased_method("G"));
        aliased_method.methodZ;

        eval(identity_obj(: aliased_method(: "H" :) :));
        identity_obj.methodZ;

        eval(aliased_method(: "I" :));
        eval(identity_obj(: aliased_method :));
        identity_obj.methodZ;
      
        eval(aliased_obj.other(: "J" :));
        aliased_obj.other.methodZ;
    }        
        
ceot {=
        external_obj {
            other [&]
        }
        external_obj aliased_obj(v) = org.fundev.test.ExternalTest(v)            
        identity_obj(o) = o

        eval(identity_obj(aliased_obj(: "E" :)));
        identity_obj.e;
        aliased_obj(: "F" :);
        aliased_obj(: :).other(: "J" :);
        " - ";
        aliased_obj(: :).other.methodZ;
=}        
        
        
    public test_case external_argument_test {
        int category = external_objects
        name = "External Argument Test"
        key = "external_arg"

        expected = "ABCDE"

        dynamic show(x, y) { 
            x;
            y;
        }

        array_of_external_objs[] = [ org.fundev.test.ExternalTest.c, org.fundev.test.ExternalTest.d ]
        
        dynamic show_child(org.fundev.test.ExternalTest z) {
             z.e;
        }
        
        show(org.fundev.test.ExternalTest.a, org.fundev.test.ExternalTest.b);
        
        for x in array_of_external_objs {
            x;
        }
        
        show_child(org.fundev.test.ExternalTest("E"));
    }

extparent {=
    string[] extList = []
    string{} extMap = {}
=}

extparent ep = org.fundev.test.ExternalTest
 
etst {=
    ep.extList[0];
    ep.extMap["1"];
    ep.extMap[1];
=}      
        
    string{} string_map = {}
    string_map[] map_array = [] 
    map_array external_map_array {
         p1 [?]
         p2 [?]
         p3 [?]
         p4 [?]
         
         org.fundev.test.ExternalTest.mapArray(p1, p2);
    }
    
    external_map_array external_map_array_1 {
         p1 = "A"
         p2 = "B"
    }

    external_map_array external_map_array_2 {
         p1 = "C"
         p2 = "D"
    }


    public test_case external_map_array_test {
        int category = external_objects
        name = "External Map Array Test"
        key = "external_map_array"

        expected = "ABCD"

        string{} map_1_0 = external_map_array_1[0]
        string{} map_1_1 = external_map_array_1[1]
        string{} map_2_0 = external_map_array_2[0]
        string{} map_2_1 = external_map_array_2[1]
        
        map_1_0["item"];
        map_1_1["item"];
        map_2_0["item"];
        map_2_1["item"];
    }
    
    public test_case external_array_parameter_test {
        int category = external_objects
        name = "External Array Parameter Test"
        key = "external_array_param"

        expected = "ABC"
    
        dynamic val(x) = x
        array_1[3] = [ "x", "y", "z" ]
        array_2[3] = [ [/ x /], [/ y /], [/ z /] ]
        array_3[3] = [ val("x"), val([/ y /]), val(val("z")) ] 
        
        str1 = org.fundev.test.ExternalTest.concatElements(array_1)
        str2 = org.fundev.test.ExternalTest.concatElements(array_2)
        str3 = org.fundev.test.ExternalTest.concatElements(array_3)

        if (str1 == "xyz") [/ A /]
        else               [/ x /]
        
        if (str2 == "xyz") [/ B /]
        else               [/ x /]

        if (str3 == "xyz") [/ C /]
        else               [/ x /]
    
    }


    public test_case logic_test {
        int category = logic
        name = "Logic Test"
        key = "logic"

        expected = "ABCDEFGHIJKLMN"

        string[] ij = [ "I", "J" ]
        
        empty_array[] = []
        nonempty_array[] = [ "x" ]
        
        empty_table{} = {}
        nonempty_table{} = { "X": "x" }

        boolean TRUE = true
        boolean FALSE = false

        if (TRUE) [/ A /]
        else [/ x /]

        if (FALSE) [/ x /]
        else [/ B /]

        if (TRUE == FALSE) [/ x /]
        else if (FALSE) [/ x /]
        else [/ C /]

        for int m from 0 to 6 by 3 {
            for int i from m to (m + 3) where (i != 4) {
                if (i == 0) [/ D /]
                else if (i <= 1) [/ E /]
                else if (i < 3) [/ F /]
                else if (i >= 3) {
                    if (i > 3) [/ H /]
                    else [/ G /]
                }
            }
        }
        for int k from 0 until k > 1 {
            ij[k];
        }
        
        if (empty_array) [/ x /]
        else [/ K /]
        
        if (nonempty_array) [/ L /]
        else [/ x /]
        
        if (empty_table) [/ x /]
        else [/ M /]
        
        if (nonempty_table) [/ N /]
        else [/ x /]
    }


    public test_case conditional_inheritance_test {
        int category = logic
        name = "Conditional Inheritance Test"
        key = "conditional_inheritance"

        expected = "ABCD"

        super_1 [/ A /]
        dynamic super_1 sub_1(boolean flag) {
            if (flag) {
                super;
            } else {
                [/ B /]
            }
        }

        dynamic super_2(boolean flag) {
            if (flag) {
                [/ C /]
            } else {
                sub;
            }
        }
        dynamic super_2(flag) sub_2(boolean flag) [/ D /]

        sub_1(true);
        sub_1(false);
        sub_2(true);
        sub_2(false);
    }


    public test_case redirection_test {
        int category = redirection
        name = "Redirection Test"
        key = "redirection"

        expected = "ABCD"

        r = "x"
        c = "C"
        d = "y"
        dd = "d"

        {
            [/ A /]

        } catch {
            [/ w /]
        }

        {
            [/ X /]
            redirect r

        } catch c {
            [/ x /]

        } catch {
            [/ B /]
        }

        {
            [/ X /]
            redirect c

        } catch r {
            [/ y /] 

        } catch c {
            c;

        } catch {
            [/ z /]
        }
        
        {
            [/ X /]
            redirect (dd)

        } catch dd {
            [/ x /]

        } catch d {
            [/ D /]
        
        } catch {
            [/ y /]
        }
        
    }

a_def [/ A /]

def_of {
    definition a_def_def = definition_of("a_def")
    
    a_def_def.instantiate;
    
}

    public test_case text_utilities_test {
        int category = utilities
        name = "Text Utilities Test"
        key = "text_utils"

        expected = "ABCDEFGHI"

        abc = "ABC"
        dxf = "DxF"

        if (starts_with(abc, "A")) [/ A /]
        else [/ x /]

        if (starts_with("xyz", dxf)) [/ x /]
        else [/ B /]

        trim_leading(abc, "AB");

        replace(dxf, "x", "E");

        lead_paragraph("G<p>xxx");
        lead_paragraph("H<h6/>zzz");

        if (lead_paragraph("  <li>XYZ <blockquote id=1>xyz") == "  <li>XYZ ") [/ I /]
        else [/ x /]
    }


    public test_case char_utilities_test {
        int category = utilities
        name = "Char Utilities Test"
        key = "char_utils"

        expected = "ABCDEFGH"

        abc = "ABC"
        de = "  \r\nDE \t\r\n"
        g = "xxxG"
        h = "Hyyyy"
        
        first_char(abc);
        char_at(abc, 1);
        last_char(abc);
        first_printable_char(de);
        last_printable_char(de);
        chr$(70);
        trim_leading(g, 'x');
        trim_trailing(h, 'y');
    }


    public test_case recursion_test {
        int category = recursion
        name = "Recursion Test"
        key = "recursion"

        expected = "ABCDE"

        chars_up_to(int x) {
            if (x > 1) {
                chars_up_to(x - 1);
            }

            char c = (char) (x + 64)
            c;
        }

        chars_up_to(5);
    }


    public test_case self_referential_update_test {
        int category = recursion
        name = "Self-Referential Update Test"
        key = "self_reference"

        expected = "ABCDEFG"
        
        sru(x) = x
        string[] sru_array(w[]) = w
        
        eval(sru(: "A" :));
        
        sru(: sru :);
        
        eval(sru(: sru + sru :));
        if (sru == "AA") {
            "B";
        } else {
            "x";
        }
        sru(: sru(: sru(: "z" :) == "z" ? "y" : "x" :) == "y" ? "C" : "x" :);
        sru(: sru(: "D" :) + sru(: "E" :) :);
        
        eval(sru_array(: ["F"] :));
        sru_array[0];
        eval(sru_array(: sru_array + sru_array(: ["G"] :) :));
        sru_array[1];
    }        

srut {
 string[] sru_array(w[]) = w
 u[] = [ "U" ]
 sru_array(: ["F"] :);
 eval(sru_array(: sru_array + sru_array(: ["G"] :) :));
 sru_array[1];
 sru_array[0];
 sru_array(: u :);
 sru_array(: sru_array + sru_array(: ["G"] :) :);

}

    public test_case border_layout_test {
        int category = layouts
        name = "Border Layout Test"
        key = "border_layout"
        boolean need_exact_match = false

        expected [/
            <table><tr><td>
                <table>
                <tr><td colspan="3" align="center">ABC</td></tr>
                <tr><td>D</td><td>E</td><td>F</td></tr>
                <tr><td colspan="3" align="center">GHI</td></tr>
                </table>
            </td><td></td><td>
                <table>
                <tr><td colspan="3" align="center">JKL</td></tr>
                <tr><td>M</td><td>N</td><td>O</td></tr>
                <tr><td colspan="3" align="center">PQR</td></tr>
                </table>
            </td></tr></table>
        /]

        north = "ABC"
        west = "D"
        center = "E"
        east = "F"
        south = "GHI"

        comp_array[5] = [ "JKL", "M", "N", "O", "PQR" ]

        border_layout(null,
                      border_layout(north, west, center, east, south),
                      null,
                      border_layout(comp_array),
                      null);
    }

blt {
   comp_array[5] = [ "JKL", "M", "N", "O", "PQR" ]
   border_layout(comp_array);
}

    public test_case compass_layout_test {
        int category = layouts
        name = "Compass Layout Test"
        key = "compass_layout"
        boolean need_exact_match = false

        expected [|
            <table><tr><td>A</td>
            <td>B</td>
            <td>C</td>
            </tr><tr><td>D</td>
            <td>E</td>
            <td>F</td>
            </tr><tr><td>G</td>
            <td>H</td>
            <td>I</td>
            </tr></table>
        /]

        nw = "A"
        n = "B"
        ne = "C"
        w = "D"
        c = "E"
        e = "F"
        sw = "G"
        s = "H"
        se = "I"

        compass_layout(nw, n, ne, w, c, e, sw, s, se);
    }


    public test_case cache_test {
        int category = caching
        name = "Cache Test"
        key = "cache"

        expected = "ABCDEFGHIJKLMNOP"

        dynamic double rand = java.lang.Math.random
        double cached_rand = rand

        double a_second_cached_rand = rand

        boolean test_child {
            (cached_rand == cached_rand);
        }

        double rand_1 {
            cached_rand;
        }

        dynamic double rand_2 {
            cached_rand;
        }

        double rand_3 {
            a_second_cached_rand;
        }
        
        double rand_4 {
            double deeper_rand = a_second_cached_rand;
            
            deeper_rand;
        }

        dynamic double rand_5 {
            locally_cached_rand = rand

            locally_cached_rand;
        }
        
        double rand_6(x) { 
            rand;
        }

        /-- a reference cached in a scope is not saved between leaving and reentering
         -- the scope --/
        if (rand_5 != rand_5) [/ A /] else [/ x /]

        /-- caching should make two references cached in the same scope the same --/
        if (cached_rand == cached_rand) [/ B /] else [/ x /]
        if (rand_1 == rand_1) [/ C /] else [/ x /]
        if (rand_2 == rand_2) [/ D /] else [/ x /]

        /-- references in subscopes of the scope where a value is cached resolve to 
         -- the value in the cache --/
        if (rand_1 == cached_rand) [/ E /] else [/ x /]
        if (test_child) [/ F /] else [/ x /]
        if (rand_2 == cached_rand) [/ G /] else [/ x /]
        if (rand_1 == rand_2) [/ H /] else [/ x /]

        /-- a second reference to the dynamic value gets a new value --/
        if (a_second_cached_rand != cached_rand) [/ I /] else [/ x /]
        if (rand_3 == a_second_cached_rand) [/ J /] else [/ x /]
        if (rand_3 == rand_4) [/ K /] else [/ x /]

        /-- a dynamic instantiation of a cached value causes the value to change --/
        if (cached_rand(::) != rand_1) [/ L /] else [/ x /]
        if (cached_rand == cached_rand) [/ M /] else [/ x /]
        if (cached_rand == rand_1(::)) [/ N /] else [/ x /]

        /-- a reference cached in a scope is not saved between leaving and reentering
         -- the scope --/
        if (rand_5 != rand_5) [/ O /] else [/ x /]
        
        /-- the presence of an argument should not affext caching --/
        if (rand_6("p") == rand_6("q")) [/ P /] else [/ x /]
    }


    string[] abc = [ "A", "B", "C" ]
    string[] defg = [ "D", "E", "F", "G" ]
    string[] empty_array = []
    string[] test_array(x) = x
    array_parent {
        keep: string[] child_array(z) = z
        
        eval(child_array(: defg :));
    }
    
    array_parent array_parent_sub [/]

    array_parent cached_array_parent(array_parent ap) = ap

    public test_case cached_array_test {
        int category = caching
        name = "Cached Array Test"
        key = "cached_array"
    
        expected = "ABCDEF"
    
        eval(test_array(: empty_array :));
        for x in test_array {
            x;
        }
        
        eval(test_array(: abc :));
        for x in test_array {
            x;
        }
        
        eval(test_array(: empty_array :));
        for x in test_array {
            x;
        }
        
        eval(array_parent);
        array_parent.child_array[0];
        
        eval(array_parent_sub);
        array_parent_sub.child_array[1];
        
        eval(cached_array_parent(: array_parent_sub :));
        cached_array_parent.child_array[2];
    }

cat {=
        eval(array_parent);
        array_parent.child_array[0];
        
        eval(array_parent_sub);
        array_parent_sub.child_array[1];
        
        eval(cached_array_parent(: array_parent_sub :));
        cached_array_parent.child_array[2];
=}


    
    public test_case keep_test {
        int category = caching
        name = "Keep Test"
        key = "keep"

        expected = "ABCDEFGHIJKLMN"

        test_cache{} = {}
        static static_test_cache{} = {}

        keep_A {
            keep in test_cache:
            x = "A"

            eval(x);
        }


        keep_B {
            keep in test_cache:
            y(n) = n

            eval(y("B"));
        }

        keep_C {
            keep in test_cache:
            z(n) = n

            zz = z("C")
            
            eval(zz);
        }


        keep_D {
            keep in static_test_cache:
            x = "D"

            eval(x);
        }


        keep_E {
            keep in static_test_cache:
            y(n) = n

            eval(y("E"));
        }

        keep_F {
            keep in static_test_cache:
            z(n) = n

            zz = z("F")
            
            eval(zz);
        }

        initialized_cache[] = { "g":"G" }
        keep in initialized_cache:
        g = "x"

        /-- it's necessary to keep parent_cache, otherwise it will get
         -- thrown away when we leave scope and undo caching of child_cache
         --/
        keep: parent_cache{} = {}
        keep in parent_cache: child_cache{} = {}

        keep_H {
            keep in child_cache:
            h = "H"

            eval(h);
        }

        keep_I {
            keep as i in test_cache:
            ii = "I"
        
            eval(ii);
        }
        
        j {
            keep as this in test_cache:
            jj = "J"
            
            eval(jj);
        }

        keep_K {
            keep in test_cache:
            k(m) = m

            z = eval(k("K"));
            
            z;
        }

        l {
            keep as this in test_cache:
            ll(x) = x
            
            z = eval(ll("L"));
            
            z;
        }
        
        keep_M {
            keep as this in test_cache:
            mm(x) = x
            
            z = eval(mm("M"));
            
            z;
        }
            
        keep_M m [/]
        
        keep_N {
            keep as this in test_cache:
            nn(x) = x
            
            z = eval(nn("N"));
        }
            
        keep_N n [/]

        child_cache get_child_cache = parent_cache["child_cache"]

        keep_A; 
        keep_B;
        keep_C;
        keep_D;
        keep_E;
        keep_F;
        keep_H;
        keep_I;
        j;
        keep_K;
        l;
        m;
        n.z;

        test_cache["x"];
        test_cache["y"];
        test_cache["z"];
        static_test_cache["x"];
        static_test_cache["y"];
        static_test_cache["z"];
        g;
        get_child_cache["h"];
        test_cache["i"];
        test_cache["j"];
        test_cache["k"];
        test_cache["l"];
        test_cache["m"];
        test_cache["n"];
    }

kt {=
        keep: parent_cache{} = {}
        keep in parent_cache: child_cache{} = {}
        child_cache get_child_cache = parent_cache["child_cache"]

        keep_H {
            keep in child_cache:
            h = "H"

            eval(h);
        }
        
        keep_H;

        get_child_cache["h"];
=}

    keep_not_test {
        obj_no {
            a(x) = x
            a("z");    
        }

        obj_yes {
            keep: b(x) = x
            eval(b("B"));    
        }
        
        obj_no;
        obj_yes;
       
        obj_no.a;
        obj_yes.b;
    }


    public test_case keep_prefix_test {
        int category = caching
        name = "Keep Prefix Test"
        key = "keep_prefix"

        expected = "ABCD"

        test_cache{} = {}
        
        keep_A {
            keep in test_cache:
            x = "A"

            eval(x);
        }

        keep_B {
            keep as y in test_cache:
            w = "B"

            eval(w);
        }

        keep_C {
            keep by zkey in test_cache:
            zz {
                zkey = "z"
                "C";
            }

            eval(zz);
        }
        
        keep: keep_D {
        
           keep: d(x) = x
           
           d("D");
        }

        keep_A; 
        keep_B;
        keep_C;
        
        test_cache["x"];
        test_cache["y"];
        test_cache["z"];

        eval(keep_D);
        keep_D.d;
    }


    public test_case dynamic_keep_test {
        int category = caching
        name = "Dynamic Keep Test"
        key = "dynamic_keep"

        expected = "ABCD"

        test_cache{} = {}
        
        keep_A {
            keep by akey in test_cache: z = "A"
            akey = "a"

            eval(z);
        }

        bkey = "b"
        keep_B {
            keep by bkey in test_cache: w = "B"

            eval(w);
        }

        keep_C {
            keep by ckey in test_cache:
            zz {
                ckey = "c"
                "C";
            }

            eval(zz);
        }
        
        keep_D {
           keep by dkey in test_cache: d(x) = x
           
           dkey(k) = k
           
           dkey("d");
           d("D");
        }

        keep_A; 
        keep_B;
        keep_C;
        eval(keep_D);
                
        test_cache["a"];
        test_cache["b"];
        test_cache["c"];
        test_cache["d"];
    }

dkt {=
    test_cache{} = {}

        bkey = "b"
        keep_B {
            keep by bkey in test_cache: w = "B"

            eval(w);
        }
        
    keep_B;         
    "-";
    test_cache["b"];
=}

    public test_case nested_keep_test {
        int category = caching
        name = "Nested Keep Test"
        key = "nested_keep"

        expected = "ABCDEFGHIJK"

        test_cache{} = {}

        abcd_container(cparam, dparam) {
            keep: a(x) = x
            b(x) = x
            c = cparam
            d(x) = x
    
            a("A");
            b("B");
            c;
            d(: dparam :);
        }
        
        keep in test_cache: ijk_container(kparam) {
           i = "I"
           j(x) = x
           k(x) = x
           
           i;
           k(kparam);
        }

        eval(abcd_container("C", "D"));    

        abcd_container.a;
        abcd_container.b;
        abcd_container.c;
        abcd_container.d;

        eval(abcd_container.b(: "E" :));
        eval(abcd_container.a(: "F" :));
        abcd_container.b;

        eval(abcd_container(: "G", "H" :));

        /-- b gets reset by the preceding eval, even though the b construction is not dynamic,
         -- while a does not, because a is decorated with "keep".  When a "keep" definition
         -- is instantiated, the value persists in the cache even when the scope is re-entered,
         -- whereas an implicitly cached value does not -- hence the reentry precipitated by 
         -- the forced evaluation directly above allows b to be re-evaluated, and hence be "B" 
         -- once more.
         --/ 
        abcd_container.a; 
        if (abcd_container.b != "B") [/ x /]

        abcd_container.c;
        abcd_container.d;
        
        eval(ijk_container.j("J"));
        eval(ijk_container("K"));
        
        ijk_container.i;
        ijk_container.j;
        ijk_container.k;
    }

nkt {=
    abcd_container {
        b(x) = x
        b("B");
    }
    abcd_container;
    abcd_container.b; 
    abcd_container(: :);
    "-";
    abcd_container.b; 
=}

    public test_case cached_identity_test {
        int category = caching
        name = "Cached Identity Test"
        key = "cached_identity"

        expected = "ABCDEFG"
        sup {
            b [/ X /]
            c [?]
 
            keep: d(z) = z
            keep: child_sup child_sub(child_sup w) = w
            
            p1 [/ X /]  
            p2 [/ X /]  

            [/ X /]
        }

        sup cached_sub {
            b [/ B /]
            c [/ C /]
            
            eval(d("D"));
            eval(child_sub(child_sup_sub));

            [/ A /]
        }
        
        child_sup {
            keep: e(x) = x
        }

        child_sup child_sup_sub {  
            e("E");
        }

        sup parameterized_sub(x, y) {
            p1 = x
            p2 = y
        }

        sup identity_sub(sup s) = s        

        eval(identity_sub(: cached_sub :));
        identity_sub;
        identity_sub.b;
        identity_sub.c;
        identity_sub.d;
        identity_sub.child_sub.e;

        eval(identity_sub(: parameterized_sub("F", "G") :));
        identity_sub.p1;
        identity_sub.p2; 
    }

cit {=
        sup {
            b [/ X /]
            c [?]
 
            keep: d(z) = z
            keep: child_sup child_sub(child_sup w) = w
            
            p1 [/ X /]  
            p2 [/ X /]  

            [/ X /]
        }

        sup cached_sub {
            b [/ B /]
            c [/ C /]
            
          /---  d("D"); ---/
            child_sub(child_sup_sub);

            [/ A /]
        }
        
        child_sup {
            keep: e(x) = x
        }

        child_sup child_sup_sub {  
            e("E");
        }

        sup parameterized_sub(x, y) {
            p1 = x
            p2 = y
        }

        sup identity_sub(sup s) = s        

        cached_sub;
   /--     identity_sub;
        identity_sub.b;
        identity_sub.c;
        identity_sub.d;
        identity_sub.child_sub.e;

        eval(identity_sub(: parameterized_sub("F", "G") :));
        identity_sub.p1;
        identity_sub.p2;  ---/ 
=}

    public test_case nested_cached_identity_test {
        int category = caching
        name = "Nested Cached Identity Test"
        key = "nested_cached_identity"

        expected = "ABCDEF"

        wo {
            keep: a [/]
            keep: pl b [/]
        }
        
        vo {
            keep: f = "x"
        } 
    
        pl {
            keep: c = "x"
        }
        
        wo mwo {
            a = "A"
            pl b = mpl
        }
        
        vo mvo {
            f = "F" 
        }
        
        pl mpl {
            c = "C"
            
            "B";
        }
        
        t {
            d [/]
        }

        t mct {
            d = "D"
        }
        
        wp(wo w, vo v, z) {
            keep: wo woa = w
            keep: pl cp(pl p) = p
            keep: wo cw(wo ww) = ww
            keep: cz(y) = y
            keep: vo cv(vo vv) = vv
            
            keep: ct(t x) = x
           
            cw(woa);
            cp(woa.b);
            ct(mct);
            cz(z);
            cv(v);
        }
    
        wp mwp(wp z) = z
        
        eval(mwp(wp(mwo, mvo, "E")));
            
        mwp.cw.a;
        mwp.cp;
        mwp.cp.c;
        mwp.ct.d;
        mwp.cz;
        mwp.cv.f;
    }

hinit {=
    cnit;
    ss1;
    cnit;
=}

cnit {=
        wo {
            keep: a [/]
            keep: pl b [/]
        }
        
        vo {
            keep: f = "x"
        } 
    
        pl {
            keep: c = "x"
        }
        
        wo mwo {
            a = "A"
            pl b = mpl
        }
        
        vo mvo {
            f = "F" 
        }
        
        pl mpl {
            c = "C"
            
            "B";
        }
        
        t {
            d [/]
        }

        t mct {
            d = "D"
        }
        
        wp(wo w, vo v, z) {
            keep: wo woa = w
            keep: pl cp(pl p) = p
            keep: wo cw(wo ww) = ww
            keep: cz(y) = y
            keep: vo cv(vo vv) = vv
            
            keep: ct(t x) = x
           
            cw(woa);
            cp(woa.b);
            ct(mct);
            cz(z);
            cv(v);
        }
    
        wp mwp(wp z) = z
        
        eval(mwp(wp(mwo, mvo, "E")));
            
        mwp.cw.a;
        mwp.cp;
        mwp.cp.c;
        mwp.ct.d;
        mwp.cz;
        mwp.cv.f;
=}

    public test_case cached_child_of_alias_test {
        int category = caching
        name = "Cached Child of Alias Test"
        key = "cached_child_of_alias"

        expected = "ABCDEFGHI"

        obj {
            child = "x"
            sub;
        }

        obj subobj_a {
            keep: child(z) = z
            child("A");
        }

        obj subobj_b(y) {
            keep: child(z) = z
            child(y);
        }
        
        obj subobj_c(v) {
            keep: val(z) = z
            child = val
            val(v);
        }
        
        dynamic show_child(obj ob) {
            ob.child;
        }
        
        obj subobj_d {
            keep: child(z) = z
            child("D");
        }
                
        obj subobj_e(y) {
            keep: child(z) = z
            child(y);
        }
                
        keep_obj_f(x) {
            keep: obj ob = subobj_f(x)
            ob;
        }  

        obj subobj_f(w) {
            keep: child(z) = z
            child(w);
        }
        
        dynamic keep_obj_g(x) {
            keep: obj ob = subobj_g(x)
            
            if (x) {
                eval(ob);
            } else {
                ob.child;
            }
        }  

        obj subobj_g(u) {
            keep: child(z) = z
            eval(child(u));
            "x";
        }
        
        keep_obj_h(x) {
            keep: obj ob = subobj_h(x)
            
            if (ob) {
                show_child(ob);
            }
        }  

        obj subobj_h(u) {
            keep: local_child(z) = z
            child = local_child

            eval(local_child(u));
            "x";
        }

        so {
            name = "x"
        }
    
        so iso(nm) {
            keep: name(y) = y
            
            name(nm);
        }
    
        so_ho(so_nm) {
            keep: so oh_so = iso(so_nm)

            eval(oh_so);
            oh_so.name;
        }        
        
        
        obj alias_obj_a = subobj_a
        obj alias_obj_b = subobj_b
        obj alias_obj_c = subobj_c
        obj alias_obj_d = subobj_d
        obj alias_obj_e = subobj_e
        obj alias_obj_f = keep_obj_f.ob

        eval(subobj_a);
        eval(subobj_b("B"));
        eval(subobj_c("C"));
        eval(subobj_d);
        eval(subobj_e("E"));
        eval(keep_obj_f("F"));
        eval(keep_obj_g("G"));

        alias_obj_a.child; 
        alias_obj_b.child;
        alias_obj_c.child;
        show_child(alias_obj_d);
        show_child(alias_obj_e);
        alias_obj_f.child;
        keep_obj_g;
        keep_obj_h("H");
        so_ho("I");
    }

ccat {=
      
        obj {
            keep: child(z) = z
            sub;
        }

        obj subobj_a {
            child("A");
        }

        obj cached_obj(obj o) = o
        
        obj aliased_cached_obj = cached_obj
        
        eval(cached_obj(subobj_a));
        
        aliased_cached_obj.child; 
=}
    
    
    public test_case cached_aliased_parameter_test {
        int category = parameters
        name = "Cached Aliased Parameter Test"
        key = "cached_aliased_parameter"

        expected = "ABC"

        base_obj {
            a = "x"
            b = "x"
            c = "x"
            a;
            b;
            c;
        }

        base_obj a_obj {
            a = "A"
        }

        base_obj b_obj {
            b = "B"
        }

        base_obj c_obj {
            c = "C"
        }

        container_obj(base_obj obj) {
            keep: base_obj bo = obj

            bo;
        }
        
        accessor_obj(container_obj bb, container_obj cc) {
            keep: container_obj c_o = bb
            keep: base_obj b_o = cc.bo
            
            c_o;
            b_o;
        }

        eval(container_obj(a_obj));
        container_obj.bo.a;

        eval(accessor_obj(container_obj(: b_obj :), container_obj(: c_obj :)));
        accessor_obj.c_o.bo.b;
        accessor_obj.b_o.c;
    }         

capt {
        base_obj {
            a = "x"
            b = "x"
            c = "x"
            a;
            b;
            c;
        }

        base_obj a_obj {
            a = "A"
        }

        base_obj b_obj {
            b = "B"
        }

        base_obj c_obj {
            c = "C"
        }

        container_obj(base_obj obj) {
            keep:
            base_obj bo = obj

            bo;
        }
        
        accessor_obj(container_obj bb, container_obj cc) {
            container_obj c_o = bb
            base_obj b_o = cc.bo
            
            c_o;
            b_o;
        }

        eval(accessor_obj(container_obj(b_obj), container_obj(c_obj)));
        accessor_obj.c_o.bo.b;
    }         
 
         
    public test_case passed_cache_test {
        int category = caching
        name = "Passed Cache Test"
        key = "passed_cache"

        expected = "ABC"

        test_cache{} = {}
        
        populate(passed_cache{}) {
            keep in passed_cache: b(x) = x
            keep in passed_cache: c(y) = y

            table.set(passed_cache, "a", "A");
            passed_cache["a"];
            b("B");
            c("C");
        }

        eval(populate(test_cache));
        test_cache["a"];
        test_cache["b"];
        populate.c;
    }

pct {=
      test_cache{} = {}
      pop(passed_cache{}) {
         table.set(passed_cache, "a", "A");
         passed_cache["a"];
      }
      
      test_cache["x"];
      pop(test_cache);
      test_cache["a"];
=}

    public test_case keep_scope_test {
        int category = caching
        name = "Keep Scope Test"
        key = "keep_scope"

        expected = "ABCDEF"
    
        ko {
            d = "x" 
            
            "B";
        }
        
        ko mko {
            d = "D"
            
            "C";
        }
        
        dwk mdwk(dwk dd) = dd
    
        dwk(z) {
            keep: a(x) = x
            keep: ko bko(ko k) = k
            keep: ko cko(ko k) = k
            keep: e(y) = y
            keep: f(z) = z
            
            dynamic set_f {
                eval(f(: "F" :));
            }
            
            a(z);
            bko(ko);
            cko(mko);
        }

    
        eval(mdwk(dwk("A")));
        eval(mdwk.e("E"));
        eval(mdwk.f);
        mdwk.set_f;
        
        mdwk.a;
        mdwk.bko;
        mdwk.cko;
        mdwk.cko.d;
        mdwk.e;
        mdwk.f;
        
    }

kst {=
        
    dwk mdwk(dwk dd) = dd

    dwk {
        keep: f(z) = z
        
        dynamic set_f {
            f(: "F" :);
        }
    }


    mdwk(dwk);
    mdwk.f;
    mdwk.set_f;
    mdwk.f;
=}

    public test_case dynamic_argument_list_test {
        int category = parameters
        name = "Dynamic Argument List Test"
        key = "dyn_arg"

        expected = "ABCDE"
        
        ab(x) = x
        
        cd(y) {
            with (y) { y; }
            else     [/ D /]
        }
        
        eval(ab("x"));
        ab(: "A" :);
        eval(ab(: "B" :));
        ab("x");
        
        eval(cd("x"));
        cd(: "C" :);
        cd(: :);
        eval(cd(: "E" :));
        cd;
    }


    public test_case higher_order_def_test {
        int category = definitions
        name = "Higher Order Definition Test"
        key = "ho_def"

        expected = "ABCDE"

        dynamic func_1(x) {
            x;
        }

        dynamic boolean func_2(x) {
            (x == "yes");
        }
        
        dynamic func_3(ff, y) {
            ff(y);
        }

        ho_test_1(f, b) {
            f("A");
            f(b);
        }

        ho_test_2(boolean f) {
            if (f("yes")) [/ C /] else [/ x /]
            if (f("no")) [/ x /] else [/ D /]
        }

        ho_test_3(f) {
            f(func_1, "E");
        }

        ho_test_1(func_1, "B");
        ho_test_2(func_2);
        ho_test_3(func_3);
    }

hot {=
   dynamic func_1(x) {
     x;
   }
   dynamic func_3(ff, y) {
       ff(y);
   }
   ho_test_3(f) {
       f(func_1, "E");
   }
   
   ho_test(f, b) {
       f(b);
   }
   
   ho_test(func_1, "B");
   
   //ho_test_3(func_3);
=}


    public test_case type_test {
        int category = types
        name = "Type Test"
        key = "type"

        expected = "ABCDEFGHIJ"

        dynamic func_str(x) {
            x;
        }

        dynamic boolean func_bool(b) = b
        
        dynamic int func_int(n) = n
        
        j[] = [ "J" ]
        dynamic needs_default_array(a[]) {
            a[0];
        }
        
        
        dynamic needs_boolean(boolean b, when_true, when_false) {
            if (b) {
                when_true;
            } else {
                when_false;
            }
        }
 
        dynamic needs_int(int n, when_zero, when_one, when_two) {
            if (n == 0) {
                when_zero;
            } else if (n == 1) {
                when_one;
            } else if (n == 2) {
                when_two;
            } else {
                "x";
            }
        }

        needs_boolean("true", "A", "x");
        /-- note that the string "false" converts to true because it is not empty and not null ---/
        needs_boolean("false", "B", "x");  
        needs_boolean("", "x", "C");
        needs_boolean(func_bool('X'), "D", "x");
        needs_boolean(func_bool(0), "x", "E");
        needs_boolean(func_bool(1), "F", "x");
        
        needs_int("0", "G", "x", "x");
        needs_int(func_int("1"), "x", "H", "x");
        needs_int(func_int('2') - 48, "x", "x", "I");
        
        needs_default_array(j);
    }
   

    def_array[] = ["x", "y" ]
    def_table[] array_of_table = [ def_table ]
    def_table[] = {"Z": "z"}
     
    test_def_array {
        /--- show_array(def_array); ---/
        for t in array_of_table {
            show_table_z(t);
        }
    }
    show_array(a) {
        show_array_0(a);
        show_def_1(a);
    }

    show_array_0(d[]) {
        d[0];
    }
   
    show_def_1(dd) {
        dd[1];
    }
    
    show_table_z(z[]) {
        z["Z"];
    }
     
    
    public test_case expression_arg_type_test {
        int category = types
        name = "Expression Argument Type Test"
        key = "expression_arg_type"

        expected = "ABCDEFG"
        char subchar [/]
        subchar[] subchar_array = []

        int a = 1
        int[] b = [ 3, 4 ]
        float c = 5.0
        char d = 'd'
        char[] e = [ 'a', 'b' ]
        subchar f1 = 'c'
        subchar f2 = 'd'
        subchar[] g1 = [ f1, f2 ]
        subchar_array g2 = g1
        

        dynamic foo(int i),(int[] ii),(float f),(char c),(char[] cc),(subchar[] s),(subchar_array ss),(x) {
            with (i)       [/ A /]
            else with (ii) [/ B /]
            else with (f)  [/ C /]
            else with (c)  [/ D /]
            else with (cc) [/ E /]
            else with (s)  [/ F /]
            else with (ss) [/ G /]
            else           [/ x /]
        }

        foo(2 * a);
        foo(b + 1);
        foo(3 + c);
        foo(d + a);
        foo('x' + e);
        foo(f1 + g1);
        foo(g2 + f2);
    }


    expression_child_test {
        boolean no = false
        boolean yes = true
    
        foo(z) {
            a = z
        }
        
        foo f = yes ? foo("A") : foo("x")
        
        f.a;
    }


    public test_case cached_object_test {
        int category = caching
        
        name = "Cached Object Test"
        key = "cached_object"

        expected = "ABCDEFGHIJ"

        obj(xx) {
            x = xx
            x;
        }
        
        obj(*) sub_obj(zz) [/]
        
        deeper_obj(n) {
            q(yy) {
                y = yy
            }
            
            eval(obj(: "H" :));
            eval(sub_obj(: "I" :));
            eval(q(n).y);
        }
   
        obj("A");
        eval(obj(: "B" :));
        obj;
        eval(obj(: "C" :));
        obj.x;
        sub_obj(: "D" :);
        eval(sub_obj(: "E" :));
        sub_obj.x;
        eval(obj(: "F" :));
        eval(sub_obj(: "X" :));
        obj.x;
        eval(sub_obj(: "G" :));
        eval(obj(: "X" :));
        sub_obj.x;
        deeper_obj("J");
        obj.x;
        sub_obj.x;
        deeper_obj.q.y;
    }

cot {=
        obj(xx) {
            x = xx
            x;
        }
        
        obj(*) sub_obj(zz) [/]
 
        sub_obj(: "E" :);
        sub_obj.x;
        sub_obj(: "G" :);
        sub_obj.x;
=}

    public test_case aliased_sub_child_test {
        int category = instantiations
        
        name = "Aliased Sub Child Test"
        key = "aliased_sub_child"

        expected = "ABCDEF"
    
        /---- plain ----/
       
        base_def {
            child_def [/ x /]
        
            child_def;
        }
        
        base_def sub_def {
            child_def [/ A /]
        }
    
        base_def plain_def = sub_def
    
    
        /---- with param ----/
    
        base_def_param(x) {
            child_def [/ x /]
        
            child_def;
        }
        
        base_def_param(*) sub_def_param(x) {
            child_def {= x; =}
        }
    
        base_def_param def_param(z) = sub_def_param(z)
        
    
        /---- child with param ----/
    
        base_def_child_param(x) {
            child_def(y) [/ x /]
        
            child_def(x);
        }
        
        base_def_child_param(*) sub_def_child_param(x) {
            child_def(y) { y; }
        }
    
        base_def_child_param def_child_param(z) = sub_def_child_param(z)
        
    
        /---- aliased child with param ----/
    
        child_base [/ z /]
        
        child_base child_base_sub(w) = w
        
        base_def_aliased_child(x) {
            child_base child_def(y) [/]
        
            child_def(x);
        }
        
        base_def_aliased_child(*) sub_def_aliased_child(x) {
            child_base child_def(y) = child_base_sub(y)
        }
    
        base_def_aliased_child def_aliased_child(z) = sub_def_aliased_child(z)
        super_def {
            super_child [/ E /]
            super_child_2 [/ F /]
        }
        childless_def = "x"
        complex_def {
            different_child = "y"
            [/ z /]
        }
        super_def childless_alias_def = childless_def
        super_def childless_alias_def_2 = complex_def
        
        plain_def;
        def_param("B");
        def_child_param("C");
        def_aliased_child("D");
        childless_alias_def.super_child;
        childless_alias_def_2.super_child_2;
    }

    public test_case expression_comprehension_test {
        int category = arithmetic
        
        name = "Expression Comprehension Test"
        key = "expression_comprehension"

        expected = "ABC"
    
        dynamic int looped_expression = 1 + for int i = 2 to 5 {= i =}
        dynamic int iffed_expression(boolean flag) = 1 + if (flag) {= 1 =}
        
        if (looped_expression == 10)      [/ A /] else [/ x /]
        if (iffed_expression(true) == 2)  [/ B /] else [/ x /]
        if (iffed_expression(false) == 1) [/ C /] else [/ x /]
    }

public ect {=
 dynamic int looped_expression = 1 + for int i = 2 to 5 { i }
 dynamic int iffed_expression(boolean flag) = 1 + if (flag) { 1 }

 if (looped_expression == 10)      [/ A /] else [/ x /]
 if (iffed_expression(true) == 2)  [/ B /] else [/ x /]
 if (iffed_expression(false) == 1) [/ C /] else [/ x /]
=}

    public test_case children_of_parameterized_super_test {
        int category = instantiations
        name = "Children of Parameterized Super Test"
        key = "parameterized_super_children"

        expected = "ABC"
    
        super_parent(x) {
            dynamic aa = x
            dynamic bb = x
            dynamic cc = x
        }
         
        super_parent("A") aparent {
            dynamic a = aa
        }
        
        super_parent("B") bparent {
            dynamic b = bb
        }
        
        dynamic show(z) {
            z;
        }
        
        aparent.a;
        show(bparent.b);
        super_parent("C").cc;
    }
       
 
    list_all_tests {
        for test_case t in all_tests {
            if (t.expected) [/
                <br><a href="${= t.type; =}">{= t.name; =}</a>
            /]
        }
    }

    run_all_tests {
        for test_case t in all_tests {
            t;
        }
    }

show_site_name {=
 site_name;
=}
show_this_context {=
 site_name;
 br;
 this_context;
 br;
 site_name;
=}

/-----
    test_case[] test_table = [ for test_case t in all_tests {= { t.key, t } =} ]
------/

    /------------------------------------------------------------------/
    /---                           Pages                            ---/
    /------------------------------------------------------------------/

    page(r, s) basepage(request r, session s) {
        keep in global_stats: int global_page_views = global_stats["global_page_views"] + 1

        title = [/ Fun Test Suite: {= label; =} /]

        color bgcolor = "#EEDDAA"

        label [?]

        boolean ajax_enabled = true

        int min_category = 0
        int max_category = 0

        urlprefix [/]

        dynamic menuitem(basepage bp) [/
            <a href="{= urlprefix; bp.type; =}.html" title="{= bp.title; =}">{= bp.label; =}</a>
        /]

        menuitem[] menuitems = [ menuitem(index),
                                 menuitem(standard),
                                 menuitem(custom),
                                 menuitem(session_summary) ]

        leftmenu [/
            <td width="150" valign="top">&nbsp;<br>
                <table width=72 border=0 cellspacing=16 cellpadding=0>{=
                    for m in menuitems [/
                        <tr><td>{= m; =}</td></tr>
                    /]
                =}</table>
            </td>
        /]


        topbar() [/
            <div align="center"><h2>Fun Test Suite: {= label; =}</h2></div>
            <div align="right"><h3>{= today; =}</h3></div>
        /]

        form("start_session") test_session_form(session s) {
            [/ <h3>Test Session</h3> /]
            if (test_session_obj(s)) {
                [/ <p><b>Current test session: {= test_session_obj(s).getId; =}</b></p> /]
                button("command", "Stop");
                button("command", "Start over");
            } else {
                [/ <p><b>Test session not started.</b></p> /]
                disabled_button("command", "Stop");
                button("command", "Start");
            }
        }

        show_request(request r) [/
            <h3>Request Details</h3>
            <ul>
              <li>URL: {= r.url; =}</li>
              <li>query: {= r.query; =}</li>
              <li>method: {= r.method; =}</li>
            </ul>
        /]

        run_tests(request r, int min, int max) {
            test_run_form(r, min, max);
        }

        form("run") test_run_form(request r, int min, int max) {
            [/ <h3>Results</h3> /]
            for test_case t in all_tests {
                if (t.category >= min && t.category <= max) {
                    if (r.params[t.key]) {
                        t;
                        [/ <br> /]
                    } /-- else [/ test {= t.name; =} not selected.<br> /] --/
                } /-- else [/ test {= t.name; =} not in range({= min; =} to {= max; =}).<br> /] --/
            }
            button("command", "Return");
        }

        test_list(int min, int max, command),(basepage[] test_pages) {
            with (test_pages) {
                if (test_pages.count > 0) {
                    test_select_menu(test_pages);
                }
            } else {
                if (max >= min) {
                    test_select_form(min, max, command);
                }
            }
        }

        test_select_menu(basepage[] test_pages) {
            [/
               <p>This page lists tests that cannot be run in batches because they
               require interaction or do not follow the standard format for tests.</p>
               <p>Select test page to run:</p>
               <ul>
            /]

            for basepage bp in test_pages {
                [/ <li> /]
                menuitem(bp);
                [/ </li> /]
            }

            [/ </ul> /]
        }


        form("run") test_select_form(int min, int max, command) {
            boolean checked = (command != "Unselect all")

            [/
               <p>This page lists standard format tests which may be run in batches.</p>
               <p>Select tests to run:</p>
            /]
            for test_case t in all_tests {
                if (t.expected && t.category >= min && t.category <= max) {
                   checkbox(t.key, t.name, checked);
                   br;
                }
            }
            [/ <p> /]
            button("command", "Run tests");
            button("command", "Select all");
            button("command", "Unselect all");
            [/ </p> /]
        }

        content(request r, session s) {
            if (command_param(r) == "Run tests") {
                run_tests(r, min_category, max_category);
            } else {
                test_list(min_category, max_category, command_param(r));
            }
        }

        rightbar [/]

        reload [/
            <a href="$reload">reload site</a>
        /]

        footer [/
            <div align="center" style="font-size: 10pt;">
            <hr align="center" noshade >
            {= copyright; =}
            {= reload; =}
            </div>
        /]

      /------------ Construction ------------/

        eval(global_page_views);
        eval(num_page_views(: num_page_views + 1 :));        

        border_layout(topbar, leftmenu, content(r, s), rightbar, footer);
    }

   

    public basepage(r, s) index(request r, session s) {
        label = "Home"
        title = "Fun Test Suite"
        int min_category = 0
        int max_category = -1


        content(request r, session s) {
            
            // we expect this to always be called with r and s parameters

            if (!r) [/
                <p><b><font color="#EE0000">No request {= if (!s) [/ or session /] =} parameter in content!</font></b></p>
            /] else if (!s) [/
                <p><b><font color="#EE0000">No session parameter in content!</font></b></p>
            /]
               
            [/ <p>This web application is designed to test an implementation of the Fun
               language. It provides access to two kinds of tests, standard and advanced.
               Standard tests are non-interactive and report the test results in a simple,
               standardized format, making it possible to automate their execution and the
               compilation of their results.  Advanced tests, on the other hand, either
               require user interaction or cannot report results in the standard format.</p>

               <p>Select from the menu at left to view available tests.</p>
            /]

        }
    }

    public basepage(r, s) categories(request r, session s) {

        label = "Test Categories"

        content(request r, session s) {
            [/ <p>Test categories:</p><ul> /]

            for int i from 0 until i > highest_category [/
                <li><b><a href="show_tests?category={= i; =}">{= category_titles[i]; =}</a></b></li>
            /]

            [/ </ul> /]
        }
    }

    public basepage(r, s) category_page(request r, session s, cat) {

        label = category_titles[cat]

        int min_category = cat
        int max_category = cat
    }

    public basepage(r, s) show_tests(request r, session s) {
        int nnn = r.params["category"]
        label = category_titles[nnn]
        int min_category = nnn
        int max_category = nnn
    }

    public basepage(r, s) custom(request r, session s) {
        label = "Nonstandard Tests"

        content(request r, session s) {
            test_list(custom_test_pages);
        }
    }

    public basepage(r, s) standard(request r, session s) {
        label = "Standard Tests"

        int min_category = 0
        int max_category = 1000
    }

    public basepage(r, s) run(request r, session s) {
        label = (command_param(r) == "Run tests" ? "Test Results" : "Standard Tests")

        int min_category = 0
        int max_category = 1000
    }

    public basepage(r, s) session_summary(request r, session s) {
        label = "Test Session Summary"

        content(request r, session s) [/
            <table cellspacing="4">
            <tr><td><h4>Successful tests:</h4></td><td><h4>{= results["good"]; =}</h4></td></tr>
            <tr><td><h4>Failed tests:</h4></td><td><h4>{= results["bad"]; =}</h4></td></tr>
            </table>
        /]
    }


    /** for testing purposes **/
    public basepage(r, s) empty_test_page(request r, session s) {
        label = "Empty Test"

        topbar [/]
        leftmenu [/]
        footer [/]

        content(request r, session s) {
            empty_test;
            [/ <h3>Good: |]
            results["good"];
            [/ </h3> /]
        }
    }


    /---------- advanced tests ------------/

    basepage[] custom_test_pages = [ memoization_test_page, reflection_test_page, session_test_page, auto_test_page, ajax_test_page, file_test_page,
                                     cli_int_test_page, internal_mem_test, external_mem_test, exec_test_page, server_launch_test_page,
                                     base_test_test_page, error_test_page ]

    public basepage(r, s) memoization_test_page(request r, session s) {
        label = "Memoization Tests"

        content(request r, session s) {
            [/ <h3>Memoization Example</h3> /]
            memoization_example;

            [/ <p/><h3>Counter Example</h3> /]
            counter_example;

            [/ <p/><h3>Growing Array Example</h3> /]
            growing_array_example;

            [/ <p/><h3>Growing Array Example 1</h3> /]
            growing_array_example_1;

            [/ <p/><h3>Growing Array Example 2</h3> /]
            growing_array_example_2;

            [/ <p/><h3>Growing Array Example 3</h3> /]
            growing_array_example_3;

            [/ <p/><h3>Growing Array Example 4 (globally cached per-session array) </h3> /]
            growing_array_example_4(s);

            [/ <p/><h3>Mutation Example</h3> /]
            mutation_example;
        }
    }

    /** Memoization Example **/

    dynamic memoization_example {

        table_props [/ cellpadding="6" /]

            /-------- Definitions --------/

        /** Defines a table of integer named values. **/
        int values{} = {}

        /** tells the runtime system to memoize (i.e. cache evaluations of) the following
         *  function (i.e., x) in the values table defined above.
         **/
        keep in values:

        /** Defines a function that just returns its parameter. **/
        int x(int n) = n

        /** Defines a function to look up the cached value of x.  The
         *  dynamic keyword prevents x_in_cache from being cached
         *  itself, guaranteeing evaluation on every call.
         **/
        dynamic int x_in_cache = values["x"]

        /** tells the runtime system to memoize y **/
        keep in values:

        /** Defines the value y to be zero. **/
        int y = 0

        /** tells the runtime system to make the following function (set_y) a cache 
         *  alias for y, allowing set_y to modify y's cached value.
         **/
        keep as y in values:

        /** Defines a cache mutator for y. **/
        dynamic int set_y(int n) = n

        /** Defines the value z to be zero. **/
        int z = 0

        /** tells the runtime system to make set_z a cache alias for z, allowing
         *  set_z to modify z's cached value.
         **/
        keep as z:
        
        /** Defines a cache mutator for z. **/
        dynamic int set_z(int n) = n

            /------- Construction -------/

        /-- The following code uses core table-building functions to build an
         -- HTML table showing the results of two evaluations of the
         -- function x, along with the cached value of x before, between and
         -- after the evaluations.
         --/
        start_table(table_props); [/ x in cache: /]
        next_column; x_in_cache;

        next_row; [/ memoized x: /]
        next_column; x;

        next_row; [/ x(:1:): /]
        next_column; x(:1:);

        next_row; [/ memoized x: /]
        next_column; x;

        next_row; [/ x in cache: /]
        next_column; x_in_cache;

        next_row; [/ x(:2:): /]
        next_column; x(:2:);

        next_row; [/ memoized x: /]
        next_column; x;

        next_row; [/ x in cache: /]
        next_column; x_in_cache;

        end_table;

        [/ <p/> /]

        /-- The following code builds an HTML table showing initial and mutated
         -- values of y.  y is mutated using aliased caching.
         --/

        start_table; [/ initial y: /]
        next_column; y;

        next_row; [/ set_y(1): /]
        next_column; set_y(1);

        next_row; [/ memoized y: /]
        next_column; y;

        next_row; [/ set_y(2): /]
        next_column; set_y(2);

        next_row; [/ memoized y: /]
        next_column; y;

        end_table;

        [/ <p/> /]

        /-- The following code builds an HTML table showing initial and mutated
         -- values of z.  z is mutated using aliased caching, just like y above,
         -- but it uses implicit rather than explicit caching.
         --/

        start_table; [/ initial z: /]
        next_column; z;

        next_row; [/ set_z(1): /]
        next_column; set_z(1);

        next_row; [/ memoized z: /]
        next_column; z;

        next_row; [/ set_z(2): /]
        next_column; set_z(2);

        next_row; [/ memoized z: /]
        next_column; z;

        end_table;
    }

memt {=
 int z = 0;
 keep as z:
 dynamic int set_z(int n) = n
 z; set_z(3); z;
 
=}

    /** A table with one initial element, an association between an initial
     *  value of -1 and the name "n".  Because this table is defined at the
     *  site level, it is cached by session, so that values memoized in it
     *  persist through a session.
     **/
    int session_values{} = { "n": -1 }

	keep in session_values:
	boolean initialized = false
	
    /** Site initialization test **/
    boolean init {
        keep in session_values:
        dynamic boolean initialized = true
        initialized;
    }
    

    /** A counter.  Returns consecutive integers on each call, starting
     *  with zero.  Declared dynamic to force evaluation every time it is
     *  referenced.
     **/
    dynamic counter_example {
        /** A table with one initial element, an association between an initial
         *  value of -1 and the name "n".  The static keyword means the table
         *  is initialized only once rather than with each call to counter, and is
         *  therefore shared across all sessions.
         **/
        static int global_values{} = { "n": -1 }


        /** A table with one initial element, an association between an initial
         *  value of -1 and the name "n".  This table will be initialized anew on
         *  every call to counter_example, even in the same session.
         **/
        int local_values{} = { "n": -1 }


        /** the counter base type **/
        dynamic int counter {
            int{} counter_cache [?]
        
            /** a simple identity function. **/
            keep in counter_cache: int n(int x) = x
        
            /** A function which increments the memoized value of n. **/
            dynamic int incr = n + 1

            /** The implementation of counter: sets n to incr, which returns the cached
             *  (previous) value of n plus one.
             */
            n(:incr:);
        }

        /** the session-level counter object **/
        dynamic counter session_counter {
            /** make session_values the cache for n **/
            int{} counter_cache = session_values
        }

        /** the global counter object **/
        dynamic counter global_counter {
            /** make global_values the cache for n **/
            int{} counter_cache = global_values

        }

        /** the local counter object **/
        dynamic counter local_counter {
            /** make local_values the cache for n **/
            int{} counter_cache = local_values
        }
        
        [/ <h4>Local Counter</h4><b> /]
        for int i from 0 through 9 {
            local_counter; sp;
        }
        [/ </b><h4>Session Counter</h4><b> /]
        for int i from 0 through 9 {
            session_counter; sp;
        }
        [/ </b><h4>Global Counter</h4><b> /]
        for int i from 0 through 9 {
            global_counter; sp;
        }
        [/ </b> /]
    }



    growing_array_example {
        char[] growing_array(char[] x) = x
        dynamic add_to_array(char c) = eval(growing_array(:growing_array + c:))
        
        [/ <b> /]
        for char letter from 'A' through 'J' {
            add_to_array(letter);
            growing_array;
            br;
        }
        [/ </b> /]
    }


    /** An array added to over time.  Grows by one element on each call, starting
     *  with an empty array.  Declared dynamic to force evaluation every time it is
     *  referenced.
     **/
    dynamic growing_array_example_1 {
        char[] empty_array = []
        array_cache{} = { "growing_array": empty_array }
        dynamic char[] _array = array_cache["growing_array"]
        dynamic char next_letter(int n) = (char) (n + (int) 'A')

        /--keep array_cache --/
        keep in array_cache:
        char[] growing_array(int n) = _array + next_letter(n)

        [/ <b> /]
        for int i from 0 through 9 {
            growing_array(:i:);  br;
        }
        [/ </b> /]
    }


    dynamic growing_array_example_2 {
        

        char letter = 'A'
        keep as letter: dynamic char incr_letter = letter + 1

        char[] array = [ letter ]
        keep as array: dynamic char[] incr_array = array + incr_letter

        [/ <b> /]
        for int i from 0 through 9 {
            array;
            br;
            eval(incr_array);
        }
        [/ </b> /]
    }


    char[] char_array = []
    dynamic growing_array_example_3 {

        char_array carray {
            keep: char[] chars = []
            keep as chars: dynamic char[] add(char c) = chars + c
        }

        [/ <b> /]
        for char letter from 'A' through 'J' {
            carray.add(letter);
            br;
        }
        [/ </b> /]
    }

    session_id(session s) = s.id
    static global_per_session_cache{} = {}

    keep by session_id in global_per_session_cache:
    char[] session_char_array = []
   
    static gps_2{} = {}

    dynamic add_to_session_char_array(char c, session s) {
        keep by session_id in gps_2: char session_c = 'a';
        
        keep by session_id in global_per_session_cache:
        dynamic char[] new_char_array(char x) = session_char_array + x

        keep by session_id in gps_2: dynamic char new_c(char y) = session_c + 1

        eval(session_id(s));
        eval(new_char_array(c));
        eval(new_c(c));
    }

    dynamic growing_array_example_4(session s) {
        eval(session_id(: s :));
        [/ <b> /]
        for char letter from 'A' through 'J' {
            add_to_session_char_array(letter, s);
            session_char_array;
            br;
        }
        [/ </b> /]
    }

page(r, s) gctest(request r, session s) {
    growing_array_example_4(s);
}


    dynamic int auto_id(table_name) {
        static int all_ids{} = { table_name: 0 }
        keep by table_name in all_ids: int next_id = curr_id + 1
        dynamic int curr_id = all_ids[table_name]
        
        next_id(: :);
        log("auto_id for " + table_name + " is " + next_id);
    }
    
    dynamic int current_id(table_name) {
        auto_id.all_ids[table_name];
        log("current_id for " + table_name + " is " + auto_id.all_ids[table_name]);
    }

    global int global_id_sequence(int n) = n
    dynamic int next_global_id = global_id_sequence(: global_id_sequence + 1 :)
    dynamic int current_global_id = global_id_sequence

    basepage(*) auto_test_page(request r, session s) {
        label = "Auto ID Test"

        content(request r, session s) {
            autotest(r.params);    
        }
    }
    
    dynamic autotest(params{}) {
        int tname = params["table"]
        boolean auto_table1 = (tname == "table1" || !tname)
        boolean auto_table2 = (tname == "table2" || !tname)
        boolean auto_table3 = (tname == "table3" || !tname)
        
        int id1 = auto_table1 ? auto_id("table1") : current_id("table1") 
        int id2 = auto_table2 ? auto_id("table2") : current_id("table2")
        int id3 = auto_table3 ? auto_id("table3") : current_id("table3")
        int id_global = next_global_id
        
        [/
            <h3>Per table</h3>
            <p>{= (auto_table1 ? "Auto" : "Current"); =} id for table1: {= id1; =}</p>
            <p>{= (auto_table2 ? "Auto" : "Current"); =} id for table2: {= id2; =}</p>
            <p>{= (auto_table3 ? "Auto" : "Current"); =} id for table3: {= id3; =}</p>
            <h3>Global</h3>
            <p>Global auto id: {= id_global; =}</p>
        /]
    }

    gtid {
        next_rsec67_id;
        br;
        current_rsec67_id;
    }

    
gid {=
 next_global_id;
 " - ";
 to67x(current_global_id);
 " - ";
 to80x(current_global_id);
 " - ";
 to128x(current_global_id);
 br;
 next_global_id;
 " - ";
 to67x(current_global_id);
 " - ";
 to80x(current_global_id);
 " - ";
 to128x(current_global_id);
 br;
 next_global_id;
 " - ";
 to67x(current_global_id);
 " - ";
 to80x(current_global_id);
 " - ";
 to128x(current_global_id);
 br;
 next_global_id;
 " - ";
 to67x(current_global_id);
 " - ";
 to80x(current_global_id);
 " - ";
 to128x(current_global_id);
 br;
 next_global_id;
 " - ";
 to67x(current_global_id);
 " - ";
 to80x(current_global_id);
 " - ";
 to128x(current_global_id);
 br;
 next_global_id;
 " - ";
 to67x(current_global_id);
 " - ";
 to80x(current_global_id);
 " - ";
 to128x(current_global_id);
 br;
 next_global_id;
 " - ";
 to67x(current_global_id);
 " - ";
 to80x(current_global_id);
 " - ";
 to128x(current_global_id);
 br;
 next_global_id;
 " - ";
 to67x(current_global_id);
 " - ";
 to80x(current_global_id);
 " - ";
 to128x(current_global_id);
 br;
 br;
 hr;
 br;
 current_minutes;
 " - ";
 to67x(current_minutes);
 " - ";
 to80x(current_minutes);
 " - ";
 to128x(current_minutes);
=}

x67 {=
 to67x(next_global_id);
 '/';
 to67x(current_minutes);
 br;
 to67x(current_seconds);
=}

    dynamic to67x(long n) {
        dynamic to67(long val) {
            int val_mod = val % 67
            long next_val = val / 67

            char next_c = (char) (val_mod >= 40 ? (val_mod + 24) :
                                  val_mod == 39 ? (val_mod + 6) :
                                  val_mod == 38 ? (val_mod + 5) :
                                  val_mod >= 28 ? (val_mod + 20) :
                                  val_mod > 1 ? (val_mod + 95) :
                                  val_mod == 1 ? '$' : '*')
                          
            if (next_val) {
                to67(next_val);
            }
            next_c;
        }
        computed_to67 = to67(n)
        int len = strlen(computed_to67)
        
        if (len == 0)      { "***"; }
        else if (len == 1) { "**"; }
        else if (len == 2) { "*"; }
        
        computed_to67;
    }

    dynamic to75x(long n) {
        dynamic to75(long val) {
            int val_mod = val % 75
            long next_val = val / 75

            char next_c = (val_mod == 12 ? '#' : (val_mod + '0'))
                
            if (next_val) {
                to75(next_val);
            }
            next_c;
        }
        
        computed_to75 = to75(n >> 4)
        int len = strlen(computed_to75)
        
        if (len == 0)      { "000"; }
        else if (len == 1) { "00"; }
        else if (len == 2) { "0"; }
        
        computed_to75;
        hex((int) (n & 15)); 
    }

    dynamic to80x(long n) {
        // 0-79 map to 48-127
        // except:
        //   10-15 map to 194-199
        //   43-48 map to 219-224
        //   75-79 map to 251-255
        dynamic int adj(val_mod) = (val_mod >= 10 ? 136 : 0) + (val_mod > 15 ? -136 : 0) +
                                   (val_mod >= 43 ? 128 : 0) + (val_mod > 48 ? -128 : 0) +
                                   (val_mod >= 75 ? 128 : 0) + val_mod

        dynamic to80(long val) {
            int val_mod = val % 80
            long next_val = val / 80
                               
            char next_c = adj(val_mod) + '0'

            if (next_val) {
                to80(next_val);
            }
            next_c;
        }
        
        computed_to80 = to80(n)
        int len = strlen(computed_to80)
        
        if (len == 0)      { "00"; }
        else if (len == 1) { "0"; }

        computed_to80;
    }


    dynamic to128x(long n) {
        dynamic to128(long val) {
            int val_mod = val & 127
            long next_val = val >> 7
            // 63-127 map to ascii 191-255
            // 37-62 map to 'a' to 'z'
            // 10-36 map to ascii '@' to 'Z'
            // 0-9 map to '0' to '9'
            char next_c = val_mod > 62 ? (char) (val | 128)
                        : val_mod > 36 ? val_mod + '<'
                        : val_mod > 9 ? val_mod + '6' 
                        : val_mod + '0'
                           
            if (next_val) {
                to128(next_val);
            }
            next_c;
        }
        
        computed_to128 = to128(n >> 4)
        int len = strlen(computed_to128)
        
        if (len == 0)      { "00"; }
        else if (len == 1) { "0"; }
        
        computed_to128;
        hex((int) (n & 15)); 
    }

    global int global_rsec67_seq(int n) = n
    dynamic int next_rsec67_seq = global_rsec67_seq(: global_rsec67_seq + 1 :)
    dynamic next_rsec67_id = current_rsec67_id(: rsec67(next_rsec67_seq) :)
    current_rsec67_id(id) = id

    dynamic rsec67(long n) {
    
        long next_id = n
        
        dynamic to67(long val) {
            int val_mod = val % 67
            long next_val = val / 67

            char next_c = (char) (val_mod >= 40 ? (val_mod + 24) :
                                  val_mod == 39 ? (val_mod + 6) :
                                  val_mod == 38 ? (val_mod + 5) :
                                  val_mod >= 28 ? (val_mod + 20) :
                                  val_mod > 1 ? (val_mod + 95) :
                                  val_mod == 1 ? '$' : '*')
                          
            if (next_val) {
                to67(next_val);
            }
            next_c;
        }

        dynamic rev67(long val) {
            int val_mod = val % 67
            long next_val = val / 67

            char next_c = (char) (val_mod >= 40 ? (val_mod + 24) :
                                  val_mod == 39 ? (val_mod + 6) :
                                  val_mod == 38 ? (val_mod + 5) :
                                  val_mod >= 28 ? (val_mod + 20) :
                                  val_mod > 1 ? (val_mod + 95) :
                                  val_mod == 1 ? '$' : '*')
                          
            next_c;
            if (next_val) {
                rev67(next_val);
            }
        }

        rev67(current_seconds);
        if (next_id < 67) { "*"; }
        to67(next_id);
    }


    dynamic timestamped_id(long n) {
        // 0-79 map to 48-127
        // except:
        //   10-15 map to 194-199
        //   43-48 map to 219-224
        //   75-79 map to 251-255
        dynamic int adj(val_mod) = (val_mod >= 10 ? 136 : 0) + (val_mod > 15 ? -136 : 0) +
                                   (val_mod >= 43 ? 128 : 0) + (val_mod > 48 ? -128 : 0) +
                                   (val_mod >= 75 ? 128 : 0) + val_mod

        dynamic to80(long val) {
            int val_mod = val % 80
            long next_val = val / 80
                               
            char next_c = adj(val_mod) + '0'

            if (next_val) {
                to80(next_val);
            }
            next_c;
        }
        
        dynamic back80(long val) {
            int val_mod = val % 80
            long next_val = val / 80
                               
            char next_c = adj(val_mod) + '0'

            next_c;
            if (next_val) {
                back80(next_val);
            }
        }

        computed_to80 = to80(n)
        int len = strlen(computed_to80)
        
        back80(current_minutes);
        
        if (len == 0)      { "00"; }
        else if (len == 1) { "0"; }

        computed_to80;
    }


    dynamic mutation_example {
        modable_object {
            keep as this in container: _get = init
            keep as this in container: dynamic _set(x) = x
            dynamic set(x) = eval(_set(x))
            dynamic get = _get
            init [?]
        }

        dynamic char, modable_object changing_letter {
            char init = 'A' - 1

            set(get + 1);
            get;
        }

        int modable_integer {
            keep as this in container: dynamic int _set(int n) = n
            keep as this in container: int _get = 0
            dynamic int _add(a, b) = a + b
            dynamic set(int val) = eval(_set(val))
            dynamic add(int val) = eval(_set(_add(_get, val)))
        }

        modable_integer z = 0
        int y = z + 1

        [/ <b> /]
        for int i from 0 to 5 {
            changing_letter;
        }

        [/ <br> /]

        z; 
        z.set(1);
        z;
        z.set(2);
        z;
        y;
        z.add(2);
        z;

        [/ </b> /]
        
    }


    foo {
        bar {
            fdeep(n) = n
            fmid(x) = x
            ftop(v) = fmid(fdeep(v))
        }
        bar.fdeep("X");
        bar.fmid(bar.fdeep("Y"));
        bar.ftop("Z");
    }

    tests {
        keep_test;
        hr;
        nested_parameter_test;
        hr;
        mutation_example;
        hr;
        foo;
    }
        

    public basepage(r, s) reflection_test_page(request r, session s) {
        label = "Reflection Tests"

        content(request r, session s) {
        
            val = "constructed"

            [/ <h4>this_domain</h4> /]
            [/ <ul><li><b>main_site: </b> /]          this_domain.main_site;
            [/ </li><li><b>sites.count: </b> /]       this_domain.sites.count;
            [/ </li><li><b>domains.count: </b> /]     this_domain.domains.count;
            [/ </li></ul> /]
            
            [/ <h4>this_processor</h4> /]
            [/ <ul><li><b>name: </b> /]               this_processor.name;
            [/ </li><li><b>version: </b> /]           this_processor.version;
            [/ </li></ul> /]
            
            [/ <h4>this_server</h4> /]
            [/ <ul><li><b>base_url: </b> /]           this_server.base_url;
            [/ </li><li><b>file_base: </b> /]         this_server.file_base;
            [/ </li><li><b>nominal_address: </b> /]   this_server.nominal_address;
            [/ </li></ul> /]
            
            [/ <h4>here</h4>  /]
            [/ <ul><li><b>site_name: </b> /]          {= here.site_name;        =} catch {= "<b>Error</b>"; =}
            [/ </li><li><b>get("val"): </b> /]        {= here.get("val");       =} catch {= "<b>Error</b>"; =} 
            [/ </li><li><b>construct("val"): </b> /]  {= here.construct("val"); =} catch {= "<b>Error</b>"; =}
            [/ </li><li><b>get("val"): </b> /]        {= here.get("val");       =} catch {= "<b>Error</b>"; =}
            [/ </li><li><b>val: </b> /]               {= val;                   =} catch {= "<b>Error</b>"; =}
            [/ </li><li><b>get("val"): </b> /]        {= here.get("val");       =} catch {= "<b>Error</b>"; =}
            [/ </li></ul> /]

            [/ <h4>environment variables</h4> /]
            [/ <ul><li><b>BENTO_HOME: </b> /]         $("BENTO_HOME");
            [/ </li><li><b>HOME: </b> /]              $("HOME");
            [/ </li><li><b>HOSTNAME: </b> /]          $("HOSTNAME");
            [/ </li><li><b>PATH: </b> /]              $("PATH");
            [/ </li></ul> /]
            
        }
    }

    site_test {
        definition site_defs = site.defs

        [/
            <p>site.full_name: {= site.full_name; =}</p
            <p>site_defs.count: {= site_defs.count; =}</p>
            <ul>defs:
        /]
           
        for definition d in site_defs [/
            <li>{=
                if (d.type) {=
                    d.type;
                =} else if (d) {=
                    "{= "; 
                    d;
                    " =}";
                =} else {=
                    "[/]";
                =}
             =}</li>
        /]

        [/ </ul> /]
    }



    public page(r, s) test_holder_page(request r, session s) {
        s.attributes["num_page_views"];
    }


    Session_value(value),(value, x) = value
    Session_object(int v1, int v2, int v3) {
        int val1 = v1
        int val2 = v2
        int val3 = v3
        val1;
        val2;
        val3;
    }
  
    public basepage(r, s) session_test_page(request r, session s) {
        label = "Session Tests"

        form("session_test_page") value_buttons {
            button("value", "yes");
            button("value", "no");
            button("nonvalue", "refresh");
            button("incvals", "increment object values");
        }

        content(request r, session s) {
            Local_value(value) = value
            Local_object(int v1, int v2, int v3) {
                int val1 = v1
                int val2 = v2
                int val3 = v3
                eval(val1);
                eval(val2);
                eval(val3);
            }
            val(x) = x
            
            int ln = (int) lv1
            int sn = (int) sv1
            
            dynamic int lv1 = Local_object.val1;
            dynamic int lv2 = Local_object.val2;
            dynamic int lv3 = Local_object.val3;
            
            dynamic int sv1 = Session_object.val1;
            dynamic int sv2 = Session_object.val2;
            dynamic int sv3 = Session_object.val3;
            
            [/
                <p><b>Local_value:</b> {= Local_value; =}<br/> 
                   <b>Session_value:</b> {= Session_value; =}</p> 
                <p><b>Local_object:</b> Local_object({= lv1; =}, {= lv2; =}, {= lv3; =}) </p>
                   <b>Session_object:</b> Session_object({= sv1; =}, {= sv2; =}, {= sv3; =}) </p> 
            /]


            if (r.params["value"]) [/

                <p></p> 
                <b>r.params["value"]:</b> {= r.params["value"]; =}
                <p></p> 
                <p><b>val:</b> {= val; =}<br/>
                   <b>val(: r.params["value"] == "yes" ? "yes" : "no" :):</b> {= val(: r.params["value"] == "yes" ? "yes" : "no" :); =}<br/>
                   <b>val:</b> {= val; =}</p>
                <p><b>Local_value(val):</b> {= Local_value(val); =}<br/> 
                   <b>Session_value(val):</b> {= Session_value(val); =}</p> 
                <p><b>Local_value:</b> {= Local_value; =}<br/>
                   <b>Session_value:</b> {= Session_value; =}</p>
                <p><b>Local_value(: val :):</b> {= Local_value(: val :); =}<br/> 
                   <b>Session_value(: val :):</b> {= Session_value(: val :); =}</p> 
                <p><b>Local_value:</b> {= Local_value; =}<br/>
                   <b>Session_value:</b> {= Session_value; =}</p>


            /] else if (r.params["incvals"]) [/

                <p></p> 
                <b>r.params["incvals"]:</b> {= r.params["incvals"]; =}
                <p>ln: {= ln; =}  sn: {= sn; =}</p> 
                <p><b>eval(Local_object({= (ln + 1); =}, {= (ln + 2); =}, {= (ln + 3); =}));</b> {= eval(Local_object((ln + 1), (ln + 2), (ln + 3))); =}<br/> 
                   <b>eval(Session_object({= (sn + 1); =}, {= (sn + 2); =}, {= (sn + 3); =});</b> {= eval(Session_object((sn + 1), (sn + 2), (sn + 3))); =}</p> 
                <p><b>Local_object:</b> Local_object({= lv1; =}, {= lv2; =}, {= lv3; =}) </p>
                   <b>Session_object:</b> Session_object({= sv1; =}, {= sv2; =}, {= sv3; =}) </p> 
                <p><b>eval(Local_object(: {= (ln + 2); =}, {= (ln + 3); =}, {= (ln + 4); =} :));</b> {= eval(Local_object(: (ln + 2), (ln + 3), (ln + 4) :)); =}<br/> 
                   <b>eval(Session_object(: {= (sn + 2); =}, {= (sn + 3); =}, {= (sn + 4); =} :));</b> {= eval(Session_object(: (sn + 2), (sn + 3), (sn + 4) :)); =}</p> 
                <p><b>Local_object:</b> Local_object({= lv1; =}, {= lv2; =}, {= lv3; =}) </p>
                   <b>Session_object:</b> Session_object({= sv1; =}, {= sv2; =}, {= sv3; =}) </p> 

            /]
 
            value_buttons;

            eg_component(r);

            [/
                <hr/>
                <h4>Page views this session: {= num_page_views; =}</h4>
                <h4>Total page views in all sessions: {= global_stats["global_page_views"]; =}</h4>
            /]
        } 
    }
    int selected_example(int n) = n
    component eg_component(request r) {
        id = "example"

        int example_arg = (int) r.params["example"]

        if (example_arg) {
            eval(selected_example(example_arg));
        }
        [/ <p>example_arg: {= example_arg; =}</p>
           <p>selected_example: {= selected_example; =}</p> /]
    }

    public basepage(r, s) file_test_page(request r, session s) {

        label = "File Test"
        
        file current_dir = file(".")
      
        file[] files = current_dir.files
        
        content(request r, session s) {
            [/ <h4>Directory of {= current_dir.canonical_path; =}</h4> /]

            [/ <ul> /]
            for file f in files {
                [/ <li> /]
                f.canonical_path;
                [/ </li> /]
            }
            [/ </ul> /]
        }
    }

ft {=
  for file f in file(".").files {=
    f.canonical_path;
  =} 
 =}


    int ajc(int x) = x
    dynamic int ajax_counter {
        ajc(: 1 + ajc :);
    }

    ajtp {
        ajax_counter;
        ajax_counter;
        ajax_counter;
    }
    
    
    public basepage(r, s) ajax_test_page(request r, session s) {

        label = "AJAX Test"
        boolean ajax_enabled = true

        
        status_msg = "Next best thing."
        
        public component top_bar(request r) {
            color bgcolor = "#8A8081"
            
            [/ <h2> /]
            with (r) {
                r.params["title"];
            } else {
                title;
            }
            [/ </h2> /]
        }
            
        component left_side_bar {
            color bgcolor = "#8B80C1"
            
            start_table;
            button("rb", "Advance counter", right_side_bar);
            next_row;
            textedit("title", "", 10, 80, top_bar.id);
            end_table;

            formlike_component;
        }
        
        component formlike_component {
            color bgcolor = "#EFCCCC"
            req_id = content_component.id
            
            [/ <table width="96%" bgcolor="{= bgcolor; =}"><tr><td>Formlike Component</td></tr><tr><td> /]
            textarea("content", "", 23, 13);
            [/ </td></tr><tr><td> /]
            submit_button("formlike_component_submit", "Submit", req_id, "content");
            [/<br>content_component.type: {= content_component.type; =}
              <br>content_component.id: {= content_component.id; =} /]
            [/ </td></tr></table> /]
        } 
            
        public component right_side_bar {
            color bgcolor = "#8AB0C1"
            
            [/ <h3> /]
            ajax_counter;
            nbsp; nbsp; nbsp;
            ajax_counter;
            nbsp; nbsp; nbsp;
            ajax_counter;
            [/ </h3> /]
        }
        
        public component content_component(request r) {
            with (r) {
                r.params["content"];
            } else [/
                <p>Interesting.</p>
            /]
        }
        
        public component bottom_bar {
            color bgcolor = "#8A8081"
            
            status_msg;
        }
        
        content(request r, session s) {
            stage_layout(left_side_bar, top_bar, content_component, bottom_bar, right_side_bar);
        }
    }        

    public basepage(r, s) cli_int_test_page(request r, session s) {

        label = "Interactive Client Test"
        boolean drag_enabled = true

        component, selectable, draggable, resizable box [/]
                
        box box_one {
            style [/
                #box_one {
                    position: absolute;
                    left: 50px; top: 10px;
                    width: 50px; height: 52px; 
                    z-index: 3;
                    background-color: #CC4466;
                    padding: 4px;
                }
            /]
            
            [/ <p>Box One</p> /]
        }

        box box_two {
            style [/
                #box_two {
                    position: absolute;
                    left: 55px; top: 80px;
                    width: 50px; height: 52px; 
                    z-index: 2;
                    background-color: #44CC66;
                    padding: 4px;
                }
            /]

            [/ <p>Box Two</p> /]
        }
        
        box box_three {
            style [/
                #box_three {
                    position: absolute; left: 60px; top: 150px;
                    width: 50px; height: 52px; 
                    z-index: 1;
                    background-color: #6644CC;
                    padding: 4px;
                }
            /]

            [/ <p>Box Three</p> /]
        }
        
        content(request r, session s) {
            box_one;
            box_two;
            box_three;

            seldeco;
        }
    }
    
    public basepage(r, s) external_mem_test(request r, session s) {
    	label = "Big external memory allocation"
    
        
        content(request r, session s) {
            [/ <h4>big array</h4> /]
    	    big_mem_allocator;
    	    [/ <p>ok.</p> /]
    	}
    }
    
    big_mem_allocator {=
    	eval(org.fundev.test.ExternalTest.bigObjects);
	=}    	

    public basepage(r, s) internal_mem_test(request r, session s) {
    	label = "Big internal memory allocation"
    	
    	big_array[] = [ for int i from 0 to 1048576 {= i =} ]
    	big_array[] big_array_array = [ for int i from 0 to 256 {= big_array =} ]

		length = big_array_array.count * 1048576 * 256 * 4;

        content(request r, session s) {
            [/
               <h4>big array</h4>
               <p>length = {= length; =}
               <br>last item = {= big_array_array[255][1048575]; =}
               <br>ok.</p>
            /]
        }
    }
    
    exec command_exec(cmd) = exec(cmd)
    boolean exec_is_running(boolean running) = running

    allowed_commands[] = [ "cat", "ls", "echo", "ps", "date", "help", "pwd" ]

    dynamic safe_command(command) {
        words[] = split(command, " ")
        if (words[0] in allowed_commands) {
            command;
        }
    }
    
    public basepage(r, s) exec_test_page(request r, session s) {
        label = "External command exec test"
        boolean ajax_enabled = true

        component input_panel(params{}) {
            [/ <table><tr><td> /]
            textedit("command_in", params["command_in"], 23);
            [/ </td></tr><tr><td> /]
            submit_button("input_panel_submit", "Execute", "command_out", "command_in");
            [/ </td></tr></table> /]
        }    
        
        dynamic component command_out(params{}) {
            id = "command_out"
            safe_command_in = safe_command(params["command_in"])
            
            log("exec_is_running: " + exec_is_running);
            if (!safe_command_in && params["command_in"]) {
                "Only the following commands allowed: ";
                for cmd in allowed_commands and int x from 0 {
                    if (x > 0) { ", "; }
                    cmd;
                }
            
            } else if (exec_is_running) {
                if (params["command_in"]) {
                    eval(command_exec.read_in(safe_command_in));
                }
            
            } else if (params["command_in"]) {
                log("running exec " + params["command_in"]);
                [/ <tt>$&nbsp; /]
                command_exec(: safe_command_in :);
                eval(exec_is_running(: true :));
                br;
                for int i from 0 until (!command_exec.is_running) {
                    if (!command_exec.has_err && !command_exec.has_out) {
                        sleep(50);
                    } else {
                        show_out;
                    }
                }
                eval(exec_is_running(: false :));
                show_out;
                log("done with exec " + params["command_in"]);
                [/ </tt> /]
            } else [/
                <p>(nothing to show)</p>
            /]
        }

        dynamic show_out {
            for line in lines(command_exec.err) {
                [/ <span style="color:red"> /]
                line;
                [/ </span><br/> /]
            }
            for line in lines(command_exec.out) {
                line;
                br;
            }
        }
        
        content(request r, session s) {
            input_panel(r.params);
            command_out(r.params); 
        }
        
    }
    
    public basepage(r, s) server_launch_test_page(request r, session s) {
        label = "Server Launch Test"

        form("server_launch_test_page") control_panel {
            button("launch", "Launch");
            sp;
            button("status", "Get data");
        }

        test_server_funpath = main_site.funpath + "/test_server" 
        
        server_params{} = {}

        server_params test_server_params = { "funpath": test_server_funpath }
                                
        launch_test_server {
            eval(this_server.launch_server("test_server", test_server_params));
        }
       
        dynamic boolean server_started = (this_server.get_server("test_server") != null);
        dynamic boolean server_is_running = (server_started && this_server.get_server("test_server").is_running);
        
        dynamic get_a = this_server.get_server("test_server").get("a")
        dynamic deserializable(this_server.get_server("test_server").get("bc")) get_bc [/]
        dynamic deserializable(this_server.get_server("test_server").get("de")) get_de [/]

        bc[] = get_bc
        de{} = get_de
         
        content(request r, session s) {
            log("test_server funpath: " + test_server_funpath);
        
            if (r.params["launch"]) {
                log("launching " + test_server_params["site"]);       
                launch_test_server;
            }
            
            [/
                <p><b>test_server started:</b> {= server_started; =}</p> 
                <p><b>test_server running:</b> {= server_is_running; =}</p> 
            /]
            
            if (r.params["status"]) [/
                <table>
                <tr><td><b>expected data from test_server:</b></td><td>ABCDE</td></tr> 
                <tr><td><b>actual data from test_server:</b></td><td>{= get_a; bc[0]; bc[1]; de["d"]; de["e"]; =}</td></tr>
                </table> 
            /]
            
            control_panel;
        }    
    
    }
    
    type_checking_test {
        foo1(x) = x
        int foo2(x) = x
        foo3(int x) = x
        int foo4(int x) = x
        int foo5(int x) = x + 5
        int fooyou(int x), (float y), (z) {
            with (x) {
                x.type; ": ";
                [/ int: /] sp;
                x;
            } else with (y) {
                y.type; ": ";
                [/ float: /] sp;
                y;
            } else with (z) {
                z.type; ": ";
                [/ untyped: /] sp;
                z;
            }
        }
        
        [/ <p>foo1("abc") = /]
        foo1("abc");
        [/ <p>foo2("abc") = /]
        foo2("abc");
        [/ <p>foo3("abc") = /]
        foo3("abc");
        [/ <p>foo4("abc") = /]
        foo4("abc");
        [/ <p>foo4("abc") + 5 = /]
        (foo4("abc") + 5);
        [/ <p>5 + foo4("abc") = /]
        (5 + foo4("abc"));
        [/ <p>foo5("abc") = /]
        foo5("abc");
        [/ <p>fooyou(1), fooyou(1.1), fooyou("abc") = /]
        sp; fooyou(1); ", "; fooyou(1.1); ", "; fooyou("abc");
    }


    zyx {
        florb {
            put(int n, xyz w) {
                "<p>n = ";
                n;
                ", pin = ";
                w.pin;
                ", qin = ";
                w.qin;
            }
        } 
    }

    zwyzx = zyx.florb

    int arf = 7
    
    xyz(p, q) {
       pin = p
       qin = q
       
       "<p>here:";
       zwyzx.put(arf, this);
    }
       
    
    child_args_test {
        xyz("hi", "ho");
        xyz("lie", "low");
    }
    
    tokenize_test {
        str = "hello my name is jello"
        
        string[] words = tokenize(str, " ");
        
        for w in words {
            w; br;
        }
    
    }
    
    public page(r, s) anim_test_page(request r, session s) {
        label = "Animation Test"
        boolean animation_enabled = true
        
    }


    animation_test {=
    
    =}
    
    
    public basepage(r, s) base_test_test_page(request r, session s) {

        label = "Test Core Test Features"
    
        content(request r, session s) {
            /--- run all the tests in test_test_runner --/        
            test_test_runner.run;
        
            [/ <h2>Test Results</h2><ol> /]
            for test_result rslt in test_test_runner.results {
                [/ <li>Name: {= rslt.name; =}<br>
                      Passed: {= rslt.result; =}<br>
                      log:<ul>
                /]
                for msg in rslt.messages [/
                    <li>{= msg; =}</li>
                /]
                [/ </ul></li> /]                
            }
            [/ </ol> /]
        }
    }
    
    test_runner test_test_runner {
    
        test_base test_that_passes {
            expected = "A"
            
            test_log("this test is expected to pass");
            test_log("this is the second message logged in this test");
    
            "A";
        }
    
        test_base test_that_fails {
            expected = "A"
        
            test_log("this is the first message logged in this test");
            test_log("this test is expected to fail");
        
            "x";
        }
    }
    
    
tbt {
  test_result[] test_results = test_test_runner.results
  test_test_runner.run;
  
  for test_result tr in test_results {
      for msg in tr.messages { msg; }
      tr.result;
      tr.name;
  }
}

tlm {
        test_result tr = test_result(: "test", true, logged_messages :)
        test_result[] trs = [ tr ]

        /** accumulator for logging messages **/
        string[] logged_messages(msgs[]) = msgs
        
        /** a test can log a message at any point **/
        dynamic test_log(msg) {
            eval(logged_messages(: logged_messages + msg :));
        }

        test_log(" a message ");
        "----";
        for test_result ttr in trs {
          for msg in ttr.messages {
              msg;
          }
        }
}

    tloop {
        tp {
            int nr = 0
            
            int ap[] = [ for int n from 0 to nr {= n =} ]
            
        }
        
        tp[] tps = [ tp1 ]
        
        tp tp1 {
            int nr = 5
        }
        
        for int p in tps[0].ap {
            p;
            sp;
        }
    }


    public basepage(r, s) error_test_page(request r, session s) {
        label = "Error Tests"

        dynamic throw_null_pointer = org.fundev.test.ErrorTest.throwNullPointerException
        dynamic throw_class_not_found = org.fundev.test.ErrorTest.throwClassNotFoundException
        dynamic throw_no_such_method = org.fundev.test.ErrorTest.throwNoSuchMethodException
        dynamic throw_number_format = org.fundev.test.ErrorTest.throwNumberFormatException
        dynamic throw_illegal_argument = org.fundev.test.ErrorTest.throwIllegalArgumentException
        dynamic throw_no_class_def_found = org.fundev.test.ErrorTest.throwNoClassDefFoundError
        dynamic throw_redirection = org.fundev.test.ErrorTest.throwRedirection
        dynamic throw_404_redirection = org.fundev.test.ErrorTest.throw404Redirection
        
        dynamic content(request r, session s) {
            generate_error = r.params["error"]
            
            if (generate_error == "nullpointer") {
                throw_null_pointer;
            } else if (generate_error == "classnotfound") {
                throw_class_not_found;
            } else if (generate_error == "nosuchmethod") {
                throw_no_such_method;
            } else if (generate_error == "numberformat") {
                throw_number_format;
            } else if (generate_error == "illegalargument") {
                throw_illegal_argument;
            } else if (generate_error == "noclassdeffound") {
                throw_no_class_def_found;
            } else if (generate_error == "redirection") {
                throw_redirection;
            } else if (generate_error == "404redirection") {
                throw_404_redirection;
            }
            
            [/
                <h2>Errors</h2><ul>
                <li><a href="error_test_page?error=nullpointer">null pointer exceptionr</a></li>
                <li><a href="error_test_page?error=classnotfound">class not found exception</a></li>
                <li><a href="error_test_page?error=nosuchmethod">no such method exception</a></li>
                <li><a href="error_test_page?error=numberformat">number format exception</a></li>
                <li><a href="error_test_page?error=illegalargument">illegal argument exception</a></li>
                <li><a href="error_test_page?error=noclassdeffound">no class def found error</a></li>
                <li><a href="error_test_page?error=redirection">redirection</a></li>
                <li><a href="error_test_page?error=404redirection">redirection to 404 error</a></li>
                </ul>
            /]                          
        }
    }

}
