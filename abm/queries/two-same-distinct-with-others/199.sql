select avg(distinct v1) count(distinct v1) count(v0), sum(v0), avg(v0), min(v0), max(v0) from t12_2 group by k;
