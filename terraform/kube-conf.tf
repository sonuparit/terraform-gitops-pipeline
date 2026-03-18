# Auto configure the kubectl after the creation of cluster
resource "null_resource" "configure_kubectl" {

  triggers = {
    cluster_name = module.retail_app_eks.cluster_name
  }

  depends_on = [module.retail_app_eks,]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.retail_app_eks.cluster_name}"
  }

}