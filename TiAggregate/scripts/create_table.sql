
create table t0_0 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null
);


create table t2_0 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null
);


create table t4_0 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null
);


create table t6_0 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null
);


create table t8_0 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null
);


create table t10_0 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null
);


create table t12_0 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null
);


create table full_0 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null
);


create table t0_1 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k)
);


create table t2_1 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k)
);


create table t4_1 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k)
);


create table t6_1 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k)
);


create table t8_1 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k)
);


create table t10_1 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k)
);


create table t12_1 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k)
);


create table full_1 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k)
);


create table t0_2 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t2_2 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t4_2 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t6_2 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t8_2 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t10_2 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t12_2 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table full_2 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t0_3 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k),
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t2_3 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k),
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t4_3 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k),
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t6_3 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k),
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t8_3 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k),
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t10_3 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k),
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table t12_3 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k),
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);


create table full_3 (
    k     bigint not null,
    v0    bigint not null,
    v1    bigint not null,
    v2    bigint not null,
    v3    bigint not null,
    v4    bigint not null,
    v5    bigint not null,
    v6    bigint not null,
    v7    bigint not null,
    vfull bigint not null,
    index idx_k(k),
    index idx_kv0(k, v0),
    index idx_kv1(k, v1),
    index idx_kv2(k, v2),
    index idx_kv3(k, v3),
    index idx_kv4(k, v4),
    index idx_kv5(k, v5),
    index idx_kv6(k, v6),
    index idx_kv7(k, v7),
    index idx_kvfull(k, vfull)
);

