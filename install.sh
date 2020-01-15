# TODO - how to handle versions?
cd $GOPATH/src/nortonlifelock || exit

git clone https://github.com/nortonlifelock/aegis-scaffold.git
git clone https://github.com/nortonlifelock/aegis.git
git clone https://github.com/nortonlifelock/aegis-api.git
git clone https://github.com/nortonlifelock/aegis-db.git
git clone https://github.com/nortonlifelock/aegis-ui.git

go install aegis/aegis.go
go install aegis-api/aegis-api.go
go install aegis-scaffold/aegis-scaffold.go
go install aegis-setup/install-config/install-config.go
go install aegis-setup/install-db/install-db.go

install-config -path $GOPATH/src/nortonlifelock

# sudo required because go modules don't allow reading
# TODO is there a way to avoid sudo?
# TODO avoid procedure flag - separate db procedure generation from go code procedure generation
sudo aegis-scaffold -config app.json \
    -cpath $GOPATH/src/nortonlifelock \
    -domain $GOPATH/pkg/mod/github.com/nortonlifelock/domain\@v1.0.0 \
    -dal $GOPATH/pkg/mod/github.com/nortonlifelock/database\@v1.0.0 \
    -sproc $GOPATH/src/nortonlifelock/aegis-db/procedures \
    -migrate $GOPATH/src/nortonlifelock/aegis-db/migrations \
    -tpath $GOPATH/src/nortonlifelock/aegis-scaffold -m -p
  
install-db -path $GOPATH/src/nortonlifelock/app.json