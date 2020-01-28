if ! command -v go > /dev/null;
  then echo 'You must have a go version supporting go modules'; exit;
fi

if [ -z "$GOPATH" ]
  then echo "\$GOPATH must be set"; exit;
fi

cd $GOPATH/src/nortonlifelock || exit

git clone https://github.com/nortonlifelock/aegis-scaffold.git
git clone https://github.com/nortonlifelock/aegis.git
git clone https://github.com/nortonlifelock/aegis-api.git
git clone https://github.com/nortonlifelock/aegis-db.git
git clone https://github.com/nortonlifelock/aegis-ui.git

cd $GOPATH/src/nortonlifelock/aegis || exit
go install aegis.go

cd $GOPATH/src/nortonlifelock/aegis-api || exit
go install aegis-api.go

cd $GOPATH/src/nortonlifelock/aegis-scaffold || exit
go install aegis-scaffold.go

cd $GOPATH/src/nortonlifelock/aegis-setup || exit
go install install-config/install-config.go
go install install-org/install-org.go

install-config -path $GOPATH/src/nortonlifelock

aegis-scaffold -config app.json \
    -cpath $GOPATH/src/nortonlifelock \
    -sproc $GOPATH/src/nortonlifelock/aegis-db/procedures \
    -migrate $GOPATH/src/nortonlifelock/aegis-db/migrations \
    -tpath $GOPATH/src/nortonlifelock/aegis-scaffold -m -p
  
install-org -path $GOPATH/src/nortonlifelock/app.json