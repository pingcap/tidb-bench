select avg(distinct v2) count(distinct v3) count(v0), sum(v0), avg(v0), min(v0), max(v0) from t6_3 group by k;