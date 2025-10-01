DROP FUNCTION get_ev_tree;
CREATE OR REPLACE FUNCTION get_ev_tree(
    p_ad_client_id numeric,
    p_ad_org_id numeric,
    p_parent_id numeric DEFAULT 0,
    p_depth integer DEFAULT 1,
    p_value_path varchar[] DEFAULT '{}',
    p_name_path varchar[] DEFAULT '{}',
	p_last_id numeric DEFAULT NULL
)
RETURNS TABLE (
	c_elementvalue_id numeric,
	lv0_value character varying, lv0_name character varying,
    lv1_value character varying, lv1_name character varying,
    lv2_value character varying, lv2_name character varying,
    lv3_value character varying, lv3_name character varying,
    lv4_value character varying, lv4_name character varying,
    lv5_value character varying, lv5_name character varying,
    lv6_value character varying, lv6_name character varying
)
AS $$
DECLARE
    r RECORD;
    tree_id numeric;
    new_path_val varchar[];
    new_path_name varchar[];
	new_last_id numeric;
BEGIN
    IF p_depth > 6 THEN
        lv0_value := p_value_path[1]; lv0_name := p_name_path[1];
        lv1_value := p_value_path[2]; lv1_name := p_name_path[2];
        lv2_value := p_value_path[3]; lv2_name := p_name_path[3];
        lv3_value := p_value_path[4]; lv3_name := p_name_path[4];
        lv4_value := p_value_path[5]; lv4_name := p_name_path[5];
        lv5_value := p_value_path[6]; lv5_name := p_name_path[6];
        lv6_value := p_value_path[7]; lv6_name := p_name_path[7];
        c_elementvalue_id := p_last_id;
        RETURN NEXT;
        RETURN;
    END IF;

    SELECT ad_tree_id INTO tree_id
    FROM ad_tree
    WHERE treetype = 'EV'
      AND ad_client_id = p_ad_client_id
      AND ad_org_id IN (0, p_ad_org_id)
    ORDER BY ad_org_id DESC
    LIMIT 1;

    IF tree_id IS NULL THEN
        RETURN;
    END IF;

    FOR r IN
        SELECT ev.c_elementvalue_id, ev.value, ev.name
        FROM ad_treenode tn
        JOIN c_elementvalue ev
          ON ev.c_elementvalue_id = tn.node_id
         AND ev.ad_client_id = p_ad_client_id
         AND ev.ad_org_id = tn.ad_org_id
        WHERE tn.ad_tree_id = tree_id
          AND tn.parent_id = p_parent_id
          AND ev.isSummary = 'Y'
    LOOP
        new_path_val := p_value_path || r.value;
        new_path_name := p_name_path || r.name;
		new_last_id := r.c_elementvalue_id;

		c_elementvalue_id := new_last_id;
        lv0_value := new_path_val[1]; lv0_name := new_path_name[1];
        lv1_value := new_path_val[2]; lv1_name := new_path_name[2];
        lv2_value := new_path_val[3]; lv2_name := new_path_name[3];
        lv3_value := new_path_val[4]; lv3_name := new_path_name[4];
        lv4_value := new_path_val[5]; lv4_name := new_path_name[5];
        lv5_value := new_path_val[6]; lv5_name := new_path_name[6];
		lv6_value := new_path_val[7]; lv6_name := new_path_name[7];

        RETURN NEXT;

        RETURN QUERY
        SELECT * FROM get_ev_tree(
            p_ad_client_id,
            p_ad_org_id,
            r.c_elementvalue_id,
            p_depth + 1,
            new_path_val,
            new_path_name,
			new_last_id
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;
