/* Show how much memory is taken up in number of pages and Mb 
by objects from the current database*/

SELECT
	CASE
		WHEN objects.name IS NULL THEN '_Total DB'
		ELSE objects.name END AS Object_Name,
	CASE 
		WHEN indexes.name IS NULL AND objects.name IS NULL THEN NULL
		WHEN GROUPING(indexes.name) = 1 THEN '_Total Table'
		WHEN indexes.name IS NULL THEN 'Heap'
		ELSE indexes.name END AS index_name,
	COUNT(*) AS buffer_cache_pages,
	COUNT(*) * 8  AS buffer_cache_used_KB
FROM sys.dm_os_buffer_descriptors
INNER JOIN sys.allocation_units
ON allocation_units.allocation_unit_id = dm_os_buffer_descriptors.allocation_unit_id
INNER JOIN sys.partitions
ON ((allocation_units.container_id = partitions.hobt_id AND type IN (1,3))
OR (allocation_units.container_id = partitions.partition_id AND type IN (2)))
INNER JOIN sys.objects
ON partitions.object_id = objects.object_id
INNER JOIN sys.indexes
ON objects.object_id = indexes.object_id
AND partitions.index_id = indexes.index_id
WHERE allocation_units.type IN (1,2,3)
AND objects.is_ms_shipped = 0
GROUP BY GROUPING SETS ((),(objects.name),(objects.name,indexes.name))
ORDER BY Object_Name, index_name;
