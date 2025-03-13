eksctl create cluster \
--vpc-public-subnets <WorkerSubnets>
--name eks-work-cluster \
--region ap-northeast-2 \
--version 1.31 \
--nodegroup-name eks-work-nodegroup \
--node-type t4g.large \
--node 2 \
--nodes-min 2 \
--nodes-max 5
