pub mod common;
use crate::common::{assert_cmd_stdout, assert_files_eq, setup};

use std::path::PathBuf;
use tempfile::tempdir;

#[test]
fn it_loads_types() {
    let files_dir = tempdir().unwrap();
    setup(&files_dir);
    let cmd = format!(
        "load-types --hot-db-path {0} --files-dir {0}",
        files_dir.path().to_string_lossy()
    );
    assert_cmd_stdout(&cmd, "");

    let result_file = files_dir.path().join("sign_me_load_types");
    let expected_file = PathBuf::from("./tests/for_tests/load_types");
    assert_files_eq(&result_file, &expected_file);
}
