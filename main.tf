#------------------------------root/main.tf-------------------------------
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#--------------------------------------------------------------------------
#-------------variable section----------------------
variable "gitlab_token" {  
    description = "stores access key value generated from gitlab account"
}

variable "project_name" {
  default = "demo-project"
  description = "stores project name"
}

variable "group_id" {
  description = "stores project id"
}

#-------------data section--------------------------
# root group cannot be created by API call, should be 
# manualy created in UI. Sub groups are allowed
data "gitlab_group" "my_group" {
  group_id = "${var.group_id}"
}

#-------------control section-----------------------
terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
    }
  }  
}

# Configure the GitLab Provider
provider "gitlab" {
  token = "${var.gitlab_token}"
}

# Create and manage projects within your GitLab
# Add a project owned by the user
resource "gitlab_project" "new_project" {
  name = "${var.project_name}"

  visibility_level = "private"
  pipelines_enabled = "true"

  namespace_id = "${data.gitlab_group.my_group.id}"
}

#-------------output section------------------------
output "projectID" {
    value = "${gitlab_project.new_project.id}"
}

output "project_url" {
    value = "${gitlab_project.new_project.web_url}"
}