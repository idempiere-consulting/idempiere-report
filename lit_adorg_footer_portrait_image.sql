-- FUNCTION: adempiere.lit_adorg_footer_portrait_image(numeric)

-- DROP FUNCTION IF EXISTS adempiere.lit_adorg_footer_portrait_image(numeric);

CREATE OR REPLACE FUNCTION adempiere.lit_adorg_footer_portrait_image(
	p_org_id numeric)
    RETURNS bytea
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    result bytea;
BEGIN
    SELECT img.binarydata INTO result
    FROM ad_orginfo org
    LEFT JOIN ad_image img ON org.lit_banner2_id = img.ad_image_id
    WHERE org.ad_org_id = p_org_id;

    RETURN result;
END;
$BODY$;

ALTER FUNCTION adempiere.lit_adorg_footer_portrait_image(numeric)
    OWNER TO adempiere;
