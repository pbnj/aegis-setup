# TODO - how to handle versions?
cd $GOPATH/src/nortonlifelock || exit

git clone https://github.com/nortonlifelock/aegis-scaffold.git
git clone https://github.com/nortonlifelock/aegis.git
git clone https://github.com/nortonlifelock/aegis-api.git
git clone https://github.com/nortonlifelock/aegis-db.git
git clone https://github.com/nortonlifelock/aegis-ui.git

go get github.com/nortonlifelock/domain@master
go get github.com/nortonlifelock/database@master

go install aegis/aegis.go
go install aegis-api/aegis-api.go
go install aegis-scaffold/aegis-scaffold.go
go install aegis-setup/install-config/install-config.go
go install aegis-setup/install-org/install-org.go

install-config -path $GOPATH/src/nortonlifelock

aegis-scaffold -config app.json \
    -cpath $GOPATH/src/nortonlifelock \
    -domain $GOPATH/pkg/mod/github.com/nortonlifelock/domain\@v1.0.1-0.20200115222954-e687eaaa4352 \
    -dal $GOPATH/pkg/mod/github.com/nortonlifelock/database\@v1.0.1-0.20200115223011-2830f95ef135 \
    -sproc $GOPATH/src/nortonlifelock/aegis-db/procedures \
    -migrate $GOPATH/src/nortonlifelock/aegis-db/migrations \
    -tpath $GOPATH/src/nortonlifelock/aegis-scaffold -m
  
install-org -path $GOPATH/src/nortonlifelock/app.json