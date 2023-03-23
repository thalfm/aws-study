rm -v gerador-ordem-pagamento.zip
zip lambda/gerador-ordem-pagamento/index.js gerador-ordem-pagamento.zip
aws --profile=local s3 cp gerador-ordem-pagamento.zip s3://otp-lambdas/gerador-ordem-pagamento.zip