CREATE OR REPLACE FUNCTION adempiere.lit_adorg_header_landscape_image(
	p_client_id numeric,
	p_org_id numeric)
    RETURNS bytea
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	lit_rep_print_header character varying(1);
    result bytea;
BEGIN
	lit_rep_print_header = get_sysconfig('LIT_REP_PrintHeader', 'Y', p_client_id, p_org_id);

	IF lit_rep_print_header = 'Y' THEN
	    SELECT img.binarydata INTO result
	    FROM ad_orginfo org
	    LEFT JOIN ad_image img ON org.lit_banner3_id = img.ad_image_id
	    WHERE org.ad_org_id = p_org_id;
	END IF;

    RETURN result;
END;
$BODY$;

ALTER FUNCTION adempiere.lit_adorg_header_landscape_image(numeric)
    OWNER TO adempiere;
