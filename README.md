# Background
The State History plugin is a new Nodeos plugin developed by Todd Fleming at Block.one which gives us another option to query history on the EOSIO mainnet blockchain. Together with his fill-Postgres utility, we can populate a Postgresql database with historical data such as action traces, transaction traces, block states, and other interesting things such as contract table changes at every block.

### How it works:
* The plugin writes the history events to new a new directory in the `/data` directory of Nodeos.
* A separate utility `fill-Postgres` connects via websocket to the state history plugin running on Nodeos and reads from the new state history files to then insert the data into a Postgres database.
* We can then query the Postgres database for things like action traces, account information and block / transaction information.

### Advantages:
* The Postgres filler utility is decoupled from Nodeos, so if you need to rebuild your database you don't need to replay Nodeos.
* Multiple Postgres fillers can connect to the same Nodeos instance and fill 2 or more separate databases at the same time as they read from independent locations in the state history files.
* This opens the door in the future for additional database fillers to be created which read from the state history files.
* The state history plugin only inserts data that makes it into a block, and action traces are only inserted once. No data is duplicated.
* The state history plugin will automatically handle and resolve forks in realtime so the plugin will work even with Nodeos running in speculative read mode.

# Overview
The goal of this project is to create a new public API interface to allow existing dApp developers to seamlessly query the new Postgresql database format created by the state history plugin and have it return everything in the same format as the existing (now deprecated and unmaintainable) history plugin.

As ongoing development efforts continue on a new API standard with the Elastic Search plugin, this API will be maintained to that new standard as it is developed.

This will give block producers more flexibility in choosing the history backend they are most comfortable with, and further advances efforts to develop a full replacement for the existing history plugin.

# Installation
* State history plugin can be found on the EOSIO github `v1.5.0-rc1` tag: https://github.com/EOSIO/eos/
* `fill-postgres` can be found here: https://github.com/EOSIO/fill-postgresql

## Nodeos Config
Add this to your Nodeos config.ini
```
##########################################
# State History Plugin
##########################################
plugin = eosio::state_history_plugin
state-history-endpoint = 0.0.0.0:8080
trace-history = true
chain-state-history = true
##########################################
```
And start Nodeos with the flag `--disable-replay-opts`

## Tips:
* `fill-postgresql` works best on Ubuntu 18.10
* Use the `build_indexes.sh` script to create the required Postgres indexes (will take several hours depending on database hardware used)

# Requirements
Storage requirements on Nodeos as of block ~28.6M:
```
4.0K	data/snapshots
250M	data/blocks/reversible
106G	data/blocks
198G	data/state-history
3.1G	data/state
307G	data/
```

Storage requirements in Postgresql to sync everything as of block ~29.5M:
```
List of databases
Name     |    Owner     | Encoding |   Collate   |    Ctype    |       Access privileges       |   Size    | Tablespace |                Description
--------------+--------------+----------+-------------+-------------+-------------------------------+-----------+------------+--------------------------------------------
eos42freedom | eos42freedom | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                               | 3788 GB   | pg_default |
```

```
List of relations
Schema |            Name            | Type  |    Owner     |   Size   | Description
--------+----------------------------+-------+--------------+----------+-------------
 chain  | account                    | table | eos42freedom | 518 MB  |
 chain  | action_trace               | table | eos42freedom | 790 GB  |
 chain  | action_trace_auth_sequence | table | eos42freedom | 296 GB  |
 chain  | action_trace_authorization | table | eos42freedom | 297 GB  |
 chain  | action_trace_ram_delta     | table | eos42freedom | 31 GB   |
 chain  | block_info                 | table | eos42freedom | 10 GB   |
 chain  | contract_index128          | table | eos42freedom | 1843 MB |
 chain  | contract_index256          | table | eos42freedom | 158 MB  |
 chain  | contract_index64           | table | eos42freedom | 12 GB   |
 chain  | contract_index_double      | table | eos42freedom | 719 MB  |
 chain  | contract_index_long_double | table | eos42freedom | 4776 kB |
 chain  | contract_row               | table | eos42freedom | 176 GB  |
 chain  | contract_table             | table | eos42freedom | 9210 MB |
 chain  | fill_status                | table | eos42freedom | 72 kB   |
 chain  | generated_transaction      | table | eos42freedom | 39 GB   |
 chain  | global_property            | table | eos42freedom | 1256 kB |
 chain  | permission                 | table | eos42freedom | 257 MB  |
 chain  | permission_link            | table | eos42freedom | 176 kB  |
 chain  | received_block             | table | eos42freedom | 3078 MB |
 chain  | resource_limits            | table | eos42freedom | 172 MB  |
 chain  | resource_limits_config     | table | eos42freedom | 5772 MB |
 chain  | resource_limits_state      | table | eos42freedom | 4551 MB |
 chain  | resource_usage             | table | eos42freedom | 30 GB   |
 chain  | transaction_trace          | table | eos42freedom | 87 GB   |
(24 rows)
```

## Change Log  

v1.0.0:  
- Initial release porting queries to Postgresql
