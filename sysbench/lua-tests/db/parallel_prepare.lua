-- for proper initialization use --max-requests = N, where N is --num-threads
--
pathtest = string.match(test, "(.*/)") or ""

dofile(pathtest .. "common.lua")

function thread_init(thread_id)
   set_vars()
end

function create_parallel_insert(table_id)

   local index_name
   local i
   local j
   local query

   start_time = os.time()

   if (oltp_secondary) then
     index_name = "KEY xid"
   else
     index_name = "PRIMARY KEY"
   end

   i = table_id

   log_info("Inserting " .. oltp_table_size .. " records into 'sbtest" .. i .. "'")

   if (oltp_auto_inc) then
      db_bulk_insert_init("INSERT INTO sbtest" .. i .. "(k, c, pad) VALUES")
   else
      db_bulk_insert_init("INSERT INTO sbtest" .. i .. "(id, k, c, pad) VALUES")
   end

   local c_val
   local pad_val

   for j = thread_id*oltp_table_size, (thread_id+1)*oltp_table_size do

   c_val = sb_rand_str([[###########-###########-###########-###########-###########-###########-###########-###########-###########-###########]])
   pad_val = sb_rand_str([[###########-###########-###########-###########-###########]])

   if (oltp_auto_inc) then
	 db_bulk_insert_next("(" .. sb_rand(thread_id*oltp_table_size,(thread_id+1)*oltp_table_size) .. ", '".. c_val .."', '" .. pad_val .. "')")
      else
	 db_bulk_insert_next("("..j.."," .. sb_rand(thread_id*oltp_table_size,(thread_id+1)*oltp_table_size) .. ",'".. c_val .."', '" .. pad_val .. "'  )")
      end
   end

   db_bulk_insert_done()

   end_time = os.time()
   log_info("Inserting 'sbtest" .. i .. "' done, within " .. os.difftime(end_time, start_time) .. " seconds")
   
end


function event(thread_id)
   local index_name
   local i
   local tb
   
   log_info("Thread prepare"..thread_id)

   if (oltp_secondary) then
     index_name = "KEY xid"
   else
     index_name = "PRIMARY KEY"
   end

 --  for i=thread_id+1, oltp_tables_count, num_threads  do
 --     create_parallel_insert(i)
 --  end   

   tb = (thread_id%oltp_tables_count)+1
   create_parallel_insert(tb)

end
