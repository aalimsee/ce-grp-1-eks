# This is a classic Terraform state lock issue.


# ⚠️ Never Use This If…
# There’s a chance someone else (or GitHub Actions) is still actively running terraform apply on the same state — it may corrupt your state file.


🔴 Error Summary
vbnet
Error: Error acquiring the state lock
ConditionalCheckFailedException: The conditional request failed

Terraform is saying:

"A previous Terraform process (probably a failed GitHub Actions run or local session) locked the state and didn’t release it."

🧼 Safe Fix: Manually Remove the Lock
Since the lock is stored in DynamoDB, you can manually remove it only when you are sure no one else is applying.

✅ Step 1: Identify the lock table
From your config:
Table: ce-grp-1-tf-locks
Key: ce-grp-1-tfstate/eks/terraform.tfstate

✅ Step 2: Remove lock using AWS CLI
Run this:

bash
aws dynamodb delete-item \
  --table-name ce-grp-1-tf-locks \
  --key '{"LockID":{"S":"ce-grp-1-tfstate/eks/terraform.tfstate"}}' \
  --region us-east-1

Make sure you have AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and optionally AWS_SESSION_TOKEN exported if you're using temporary credentials.

✅ Step 3: Re-run Terraform
Now try again:

bash
terraform plan -out=tfplan
It should now work.



