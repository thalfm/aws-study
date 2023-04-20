<?php

namespace App;

use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

use Aws\Credentials\Credentials;
use Aws\Sqs\SqsClient;

// the name of the command is what users type after "php bin/console"
#[AsCommand(name: 'app:send-orders')]
class SendOrders extends Command
{
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        // ... put here the code to create the user
        $orders = \getenv("ORDERS_CREATED");

        // configura as credenciais de acesso à AWS
        $credentials = new Credentials(\getenv("AWS_ACCESS_KEY"), \getenv('AWS_SECRET_KEY'));

        // configura as opções do cliente SQS
        $options = [
            'region'      => 'us-east-1',
            'version'     => '2012-11-05',
            'credentials' => $credentials
        ];

        // cria um novo cliente SQS
        $client = new SqsClient($options);

        // define o nome da fila SQS
        // 'https://sqs.us-west-2.amazonaws.com/123456789012/my-queue';
        $queueUrl = \getenv("AWS_SQS_URL_ORDERS_SEND"); // substitua pelo URL da sua fila

        // define a mensagem a ser enviada

        // publica a mensagem na fila
        $result = $client->sendMessage(
            [
                'QueueUrl'    => $queueUrl,
                'MessageBody' => $orders
            ]
        );

        // exibe o ID da mensagem publicada
        $output->writeln("Mensagem publicada com sucesso. ID: " . $result['MessageId']);
        // this method must return an integer number with the "exit status code"
        // of the command. You can also use these constants to make code more readable

        // return this if there was no problem running the command
        // (it's equivalent to returning int(0))

        return Command::SUCCESS;

        // or return this if some error happened during the execution
        // (it's equivalent to returning int(1))
        // return Command::FAILURE;

        // or return this to indicate incorrect command usage; e.g. invalid options
        // or missing arguments (it's equivalent to returning int(2))
        // return Command::INVALID
    }
}