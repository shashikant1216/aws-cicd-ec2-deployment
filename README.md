# Project 1: AWS CI/CD to EC2

Status: source/configuration starter; not deployed or verified in your AWS account.
Architecture: GitHub -> CodePipeline -> CodeBuild (tests) -> CodeDeploy -> EC2.
This is an in-place, single-instance demo; deployments can interrupt service.

## Prerequisites
AWS account, billing alerts, GitHub repository, AWS CLI if desired, and Node.js 22+ locally.
Use an Ubuntu EC2 image supported by the current CodeDeploy agent. Check official agent OS support before choosing it.

## Local check
cd app
npm test
npm start
# In another terminal: curl http://localhost:3000/health

## AWS setup (manual provisioning)
1. Put THIS DIRECTORY'S CONTENTS at the root of a new GitHub repository. Commit all files.
2. Create a private S3 artifact bucket with public access blocked, encryption and versioning.
3. Create an EC2 instance role with read access only to the artifact bucket/prefix and the regional CodeDeploy agent bucket. Use an instance profile, not access keys. If using SSM, add its required managed policy and network access.
4. Launch a supported Ubuntu EC2 instance in a public subnet with an internet gateway and public IP for this demo. Tag it Project=devops-cicd. Restrict inbound TCP 3000 to YOUR public IP /32. No inbound SSH is required if using Session Manager. Allow outbound HTTPS and required package repository access.
5. On the instance run: sudo env AWS_REGION=YOUR_REGION bash bootstrap-ubuntu.sh
   Verify /usr/bin/node is Node.js 22 or newer. If your distro package is older, install a supported version from a trusted source before continuing. Verify: sudo systemctl status codedeploy-agent
6. Create a CodeDeploy service role trusting codedeploy.amazonaws.com with AWSCodeDeployRole. Create an EC2/On-premises application and in-place deployment group matching Project=devops-cicd. Select this service role, no load balancer, and CodeDeployDefault.OneAtATime. Enable automatic rollback on deployment failure.
7. Create a CodeBuild project with CodePipeline as source and artifacts, a managed Linux image that supports Node.js 22, and buildspec.yml. No privileged mode is required. Its service role needs artifact-bucket read/write plus log-group/stream creation and log writes. Scope resource permissions to this project/bucket.
8. Create a GitHub connection in AWS CodeConnections and complete authorization. Create a CodePipeline with that connection and repository/branch as source, the CodeBuild project as build, and the CodeDeploy application/deployment group as deploy. Pipeline service role needs use of this connection, artifact-bucket read/write, CodeBuild start/read status, and the CodeDeploy application/revision/deployment operations needed by this pipeline. Add KMS permissions only if using a customer-managed key. Use the AWS console-generated roles as a starting point and review scope.
9. Run pipeline. Open http://EC2_PUBLIC_IP:3000/health from the allowed IP. Change the response message in app/server.js, commit and confirm a second deployment.
10. For failure evidence, make a test fail in a temporary branch/commit; verify the build stops deployment, then revert. Capture evidence only after actually running it.

## Troubleshooting
- Build: inspect CodeBuild logs and test output.
- Deploy: /var/log/aws/codedeploy-agent/codedeploy-agent.log and deployment script logs under /opt/codedeploy-agent/deployment-root/.
- App: sudo journalctl -u devops-demo -n 100; curl localhost:3000/health.
- No deployment targets: check tags, region, agent status and instance role.
- Permission errors: inspect the failing action and resource; do not grant AdministratorAccess to solve them.

## Cleanup
Delete pipeline, build project, deployment group/application, GitHub connection if unused, EC2 instance and unattached EBS volumes. Empty/delete the artifact bucket (including versions), logs and unused IAM roles. Check for remaining billable resources.

## References
https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html
https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent.html
https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html
