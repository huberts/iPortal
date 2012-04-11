# --- Created by Ebean DDL
# To stop Ebean DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table map_layer (
  id                        bigint not null,
  map_wms_id                bigint not null,
  name                      varchar(255),
  default_visible           boolean,
  can_be_used               boolean,
  constraint pk_map_layer primary key (id))
;

create table map_wms (
  id                        bigint not null,
  url                       varchar(255),
  constraint pk_map_wms primary key (id))
;

create sequence map_layer_seq;

create sequence map_wms_seq;

alter table map_layer add constraint fk_map_layer_map_wms_1 foreign key (map_wms_id) references map_wms (id) on delete restrict on update restrict;
create index ix_map_layer_map_wms_1 on map_layer (map_wms_id);



# --- !Downs

SET REFERENTIAL_INTEGRITY FALSE;

drop table if exists map_layer;

drop table if exists map_wms;

SET REFERENTIAL_INTEGRITY TRUE;

drop sequence if exists map_layer_seq;

drop sequence if exists map_wms_seq;

