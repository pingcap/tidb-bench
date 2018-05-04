select avg(distinct v1) count(distinct v2) count(v0), sum(v0), avg(v0), min(v0), max(v0) from t4_2 group by k;
