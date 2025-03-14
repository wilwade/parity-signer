#![deny(unused_crate_dependencies)]
#![deny(rustdoc::broken_intra_doc_links)]

use definitions::navigation::TransactionCardSet;
use std::path::Path;

pub use definitions::navigation::{StubNav, TransactionAction};
mod add_specs;
use add_specs::add_specs;
pub mod cards;
use cards::Card;
pub mod check_signature;
mod derivations;
use derivations::process_derivations;
mod helpers;
mod holds;
mod load_metadata;
use load_metadata::load_metadata;
mod load_types;
use load_types::load_types;
mod message;
use message::process_message;
mod parse_transaction;
pub use parse_transaction::entry_to_transactions_with_decoding;
use parse_transaction::parse_transaction;
mod error;
#[cfg(test)]
mod tests;

pub use crate::error::{Error, Result};

/// Payload in hex format as it arrives into handling contains following elements:
/// - prelude, length 6 symbols ("53" stands for substrate, ** - crypto type, ** - transaction type),
/// see the standard for details,
/// - actual content (differs between transaction types, could be even empty)
/// actual content is handled individually depending on prelude

fn handle_scanner_input<P>(payload: &str, db_path: P) -> Result<TransactionAction>
where
    P: AsRef<Path>,
{
    let data_hex = {
        if let Some(a) = payload.strip_prefix("0x") {
            a
        } else {
            payload
        }
    };

    if data_hex.len() < 6 {
        return Err(Error::TooShort);
    }

    if &data_hex[..2] != "53" {
        return Err(Error::NotSubstrate(data_hex[..2].to_string()));
    }

    match &data_hex[4..6] {
        "00" | "02" => parse_transaction(data_hex, db_path),
        "03" => process_message(data_hex, db_path),
        "80" => load_metadata(data_hex, db_path),
        "81" => load_types(data_hex, db_path),
        "c1" => add_specs(data_hex, db_path),
        "de" => process_derivations(data_hex, db_path),
        _ => Err(Error::PayloadNotSupported(data_hex[4..6].to_string())),
    }
}

pub fn produce_output<P>(payload: &str, dbname: P) -> TransactionAction
where
    P: AsRef<Path>,
{
    match handle_scanner_input(payload, dbname) {
        Ok(out) => out,
        Err(e) => TransactionAction::Read {
            r: TransactionCardSet {
                error: Some(vec![Card::Error(e).card(&mut 0, 0)]),
                ..Default::default()
            },
        },
    }
}
