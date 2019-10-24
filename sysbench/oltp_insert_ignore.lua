#!/usr/bin/env sysbench --config-file=config

-----------------------------------
-- Insert Ignore OLTP benchmark
----------------------------------

require("oltp_common")

function create_table(drv, con, table_num)
   print(string.format("Creating table 'sbtest%d'...", table_num))
   local query = string.format([[
CREATE TABLE sbtest%d(
  id INTEGER NOT NULL,
  k INTEGER DEFAULT '0' NOT NULL,
  c CHAR(120) DEFAULT '' NOT NULL,
  pad CHAR(60) DEFAULT '' NOT NULL,
  PRIMARY KEY (id)
)]],
      table_num)

   con:query(query)

   print(string.format("Creating a secondary index on 'sbtest%d'...",
                       table_num))
   con:query(string.format("CREATE UNIQUE INDEX k_%d ON sbtest%d(k)",
                           table_num, table_num))
end

function prepare_statements()
end

function event()
  local table_name = "sbtest" .. sysbench.rand.uniform(1, sysbench.opt.tables)
  local query = string.format("INSERT IGNORE INTO %s (id, k, c, pad) VALUES ", table_name)
  for i = 1, 5 do
    -- Convert a uint32_t value to SQL INT
    local id_val = sysbench.rand.unique() - 2147483648
    local k_val = sysbench.rand.unique() - 2147483648
    local c_val = get_c_value()
    local pad_val = get_pad_value()
    if i ~= 1 then
      query = string.format("%s, (%d, %d, '%s', '%s')", query, id_val, k_val, c_val, pad_val)
    else
      query = string.format("%s (%d, %d, '%s', '%s')", query, id_val, k_val, c_val, pad_val)
    end
  end

  con:query(query)
end
