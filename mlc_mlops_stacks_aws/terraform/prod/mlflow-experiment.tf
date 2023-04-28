resource "databricks_mlflow_experiment" "experiment" {
  name        = "${local.mlflow_experiment_parent_dir}/${local.env_prefix}mlc_mlops_stacks_aws-experiment"
  description = "MLflow Experiment used to track runs for mlc_mlops_stacks_aws project."
}
