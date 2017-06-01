CREATE TABLE public."Twitter_User"
(
    account_name "char",
    PRIMARY KEY (account_name)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public."Twitter_User"
    OWNER to student;


CREATE TABLE public."Tweet"
(
    "time" timestamp without time zone,
    content character varying(140),
    PRIMARY KEY ("time")
)
    INHERITS (public."Twitter_User")
WITH (
    OIDS = FALSE
);

ALTER TABLE public."Tweet"
    OWNER to student;



CREATE TABLE public."Hashtag"
(
    hashtag character varying,
    PRIMARY KEY (hashtag)
)
WITH (
     OIDS = FALSE
);

ALTER TABLE public."Hashtag"
   OWNER to student;



CREATE TABLE public."Beinhaltet"
(
    tweet timestamp without time zone,
    hashtag character varying,
    PRIMARY KEY (tweet, hashtag)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE public."Beinhaltet"
    OWNER to student;
