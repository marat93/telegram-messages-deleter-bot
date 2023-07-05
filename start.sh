#!/bin/bash

rake db:migrate

if [ $? -eq 0 ]; then
    echo "Migrations run. Starting the bot..."
    bin/bot
else
    echo "Migrations failed. Bot not started"
fi

