cd lambdas/gerador-ordem-pagamento
rm -v gerador-ordem-pagamento.zip
zip gerador-ordem-pagamento.zip index.js
aws --profile=local s3 cp gerador-ordem-pagamento.zip s3://otp-lambdas/gerador-ordem-pagamento.zip
cd ../../