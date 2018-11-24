create index if not exists name_idx on chain.action_trace(name)
create index if not exists account_name_idx on chain.account(name);
create index if not exists action_trace_receipt_receiver_block_index_order_desc_idx on chain.action_trace(receipt_receiver, block_index DESC NULLS LAST);
create index if not exists action_trace_receipt_receiver_order_desc_idx on chain.action_trace(receipt_receiver DESC NULLS LAST);
create index if not exists action_trace_receipt_receiver_block_index_idx on chain.action_trace(receipt_receiver, block_index);
create index if not exists action_trace_receipt_receiver_idx on chain.action_trace(receipt_receiver);
create index if not exists action_trace_receipt_receiver_idx on chain.action_trace(receipt_receiver);
create index if not exists action_trace_block_index_idx on chain.action_trace(block_index);
create index if not exists contract_row_code_table_scope_primary_key_block_index_prese_idx on chain.contract_row(code, "table", scope, primary_key, block_index, present);
create index if not exists action_trace_block_index_receipt_receiver_account_name_tx_id_ix on chain.action_trace(block_index, receipt_receiver, account, name, transaction_id);
