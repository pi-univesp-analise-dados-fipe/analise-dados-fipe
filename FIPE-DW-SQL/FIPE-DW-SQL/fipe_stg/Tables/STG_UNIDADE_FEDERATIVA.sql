CREATE TABLE [fipe_stg].[STG_UNIDADE_FEDERATIVA] (
    [uf]                   SMALLINT      NULL,
    [uf_code]              VARCHAR (2)   NULL,
    [iso3166_2]            VARCHAR (5)   NULL,
    [osm_relation_id]      INT           NULL,
    [wikidata_id]          VARCHAR (10)  NULL,
    [name]                 VARCHAR (30)  NULL,
    [no_accents]           VARCHAR (30)  NULL,
    [gentilic]             VARCHAR (30)  NULL,
    [gentilic_alternative] VARCHAR (30)  NULL,
    [macroregion]          VARCHAR (20)  NULL,
    [wikipedia_pt]         VARCHAR (50)  NULL,
    [website]              VARCHAR (50)  NULL,
    [timezone]             VARCHAR (50)  NULL,
    [flag_image]           VARCHAR (250) NULL
);

