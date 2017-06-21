#!/bin/bash

if [[ $DELETE_EXSITING_DATA == "yes" ]];then
	echo "delete /data/db/*"
	rm -rf /data/db/*
fi

mongod &
sleep 5

cat >> /data/db/init.log  <<EOF
`date`
EOF

mongo <<EOF
use admin;
db.createUser(
  {
    user: "$MONGODB_HIDDEN_USER",
    pwd: "$MONGODB_HIDDEN_PWD",
    roles: [ 
        { role: "root", db: "admin"},
        { role: "clusterAdmin", db: "admin"},
        { role: "__system", db: "admin"}
    ]
  }
);
db.createUser(
  {
    user: "$MONGODB_DEF_USER",
    pwd: "$MONGODB_DEF_PWD",
    roles: [ 
        { role: "root", db: "admin"},
        { role: "clusterAdmin", db: "admin"}
    ]
  }
);
EOF
sleep 5
