cd lambdas/confirmar-envio-ordem-pagamento
rm -v confirmar-envio-ordem-pagamento.zip
zip confirmar-envio-ordem-pagamento.zip index.js
aws --profile=local s3 cp confirmar-envio-ordem-pagamento.zip s3://otp-lambdas/confirmar-envio-ordem-pagamento.zip
cd ../../