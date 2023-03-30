rm -v enviar-ordem-pagamento.zip
zip enviar-ordem-pagamento.zip index.js
aws --profile=local s3 cp enviar-ordem-pagamento.zip s3://otp-lambdas/enviar-ordem-pagamento.zip