# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table map_layer (
  id                        bigint not null,
  name                      varchar(255),
  default_visible           boolean,
  can_be_used               boolean,
  wms_id                    bigint,
  constraint pk_map_layer primary key (id))
;

create table map_source (
  id                        bigint not null,
  name                      varchar(255),
  constraint pk_map_source primary key (id))
;

create table map_wms (
  id                        bigint not null,
  name                      varchar(255),
  url                       varchar(255),
  source_id                 bigint,
  constraint pk_map_wms primary key (id))
;

create sequence map_layer_seq;

create sequence map_source_seq;

create sequence map_wms_seq;

alter table map_layer add constraint fk_map_layer_wms_1 foreign key (wms_id) references map_wms (id) on delete restrict on update restrict;
create index ix_map_layer_wms_1 on map_layer (wms_id);
alter table map_wms add constraint fk_map_wms_source_2 foreign key (source_id) references map_source (id) on delete restrict on update restrict;
create index ix_map_wms_source_2 on map_wms (source_id);



# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists map_layer;

drop table if exists map_source;

drop table if exists map_wms;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists map_layer_seq;

drop sequence if exists map_source_seq;

drop sequence if exists map_wms_seq;
