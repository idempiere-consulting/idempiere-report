-- FUNCTION: adempiere.lit_date_pattern(text)

-- DROP FUNCTION IF EXISTS adempiere.lit_date_pattern(text);

CREATE OR REPLACE FUNCTION adempiere.lit_date_pattern(
	language_code text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE pattern text;
BEGIN
	select COALESCE(datepattern, 'yyyy-MM-dd') INTO pattern from ad_language where ad_language = language_code;
	return pattern;
END
$BODY$;

ALTER FUNCTION adempiere.lit_date_pattern(text)
    OWNER TO adempiere;
