# SDK-OPERATOR

operator-sdk - Development kit for building Kubernetes extensions and tools.


Using this to build arm image of vault-secret-operator


https://sdk.operatorframework.io/docs/building-operators/golang/quickstart/
https://github.com/ricoberger/vault-secrets-operator

https://sdk.operatorframework.io/docs/installation/install-operator-sdk/

## Install GO

```sh
root@raspberrypi:~/src# wget https://golang.org/dl/go1.15.3.linux-armv6l.tar.gz
--2020-10-26 00:19:12--  https://golang.org/dl/go1.15.3.linux-armv6l.tar.gz
Resolving golang.org (golang.org)... 172.217.17.145, 2a00:1450:400e:807::2011
Connecting to golang.org (golang.org)|172.217.17.145|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://dl.google.com/go/go1.15.3.linux-armv6l.tar.gz [following]
--2020-10-26 00:19:12--  https://dl.google.com/go/go1.15.3.linux-armv6l.tar.gz
Resolving dl.google.com (dl.google.com)... 216.58.211.110, 2a00:1450:400e:809::200e
Connecting to dl.google.com (dl.google.com)|216.58.211.110|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 97957627 (93M) [application/octet-stream]
Saving to: 'go1.15.3.linux-armv6l.tar.gz'

go1.15.3.linux-armv6l.tar.gz                100%[=========================================================================================>]  93.42M  9.34MB/s    in 9.9s    

2020-10-26 00:19:22 (9.44 MB/s) - 'go1.15.3.linux-armv6l.tar.gz' saved [97957627/97957627]

root@raspberrypi:~/src# sudo tar -C /usr/local -xzf  go1.15.3.linux-armv6l.tar.gz
root@raspberrypi:~/src# vim ~/.profile
root@raspberrypi:~/src# source ~/.profile
```


## Clone and checkout operator-sdk v1.1.0

```sh
root@raspberrypi:~# cd operator-sdk/


root@raspberrypi:~/operator-sdk# git checkout v1.1.0
Note: checking out 'v1.1.0'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at 9d27e224 Release v1.1.0 (#4031)
```

## Make and install

```sh
root@raspberrypi:~/operator-sdk# make tidy
go: downloading k8s.io/client-go v0.18.8
go: downloading sigs.k8s.io/kubebuilder v1.0.9-0.20200805184228-f7a3b65dd250
go: downloading k8s.io/api v0.18.8
go: downloading k8s.io/apimachinery v0.18.8
go: downloading sigs.k8s.io/yaml v1.2.0
go: downloading github.com/operator-framework/operator-registry v1.14.3
go: downloading k8s.io/kubectl v0.18.8
go: downloading github.com/spf13/viper v1.4.0
go: downloading sigs.k8s.io/controller-runtime v0.6.2
go: downloading github.com/spf13/jwalterweatherman v1.0.0
go: downloading github.com/operator-framework/api v0.3.13
go: downloading github.com/blang/semver v3.5.1+incompatible
go: downloading github.com/onsi/ginkgo v1.12.1
go: downloading github.com/sirupsen/logrus v1.6.0
go: downloading github.com/spf13/afero v1.2.2
go: downloading sigs.k8s.io/controller-tools v0.3.0
go: downloading github.com/stretchr/testify v1.6.1
go: downloading github.com/pelletier/go-toml v1.2.0
go: downloading helm.sh/helm/v3 v3.3.4
go: downloading go.uber.org/zap v1.13.0
go: downloading golang.org/x/text v0.3.3
go: downloading github.com/go-logr/logr v0.1.0
go: downloading github.com/fatih/structtag v1.1.0
go: downloading golang.org/x/time v0.0.0-20191024005414-555d28b269f0
go: downloading k8s.io/apiextensions-apiserver v0.18.8
go: downloading github.com/googleapis/gnostic v0.3.1
go: downloading github.com/pkg/errors v0.9.1
go: downloading k8s.io/cli-runtime v0.18.8
go: downloading github.com/prometheus/client_golang v1.5.1
go: downloading github.com/imdario/mergo v0.3.9
go: downloading k8s.io/utils v0.0.0-20200603063816-c1c6865ac451
go: downloading github.com/konsorten/go-windows-terminal-sequences v1.0.3
go: downloading gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c
go: downloading github.com/iancoleman/strcase v0.0.0-20191112232945-16388991a334
go: downloading github.com/fsnotify/fsnotify v1.4.9
go: downloading github.com/ghodss/yaml v1.0.0
go: downloading github.com/gobuffalo/flect v0.2.1
go: downloading github.com/golang/protobuf v1.4.2
go: downloading github.com/operator-framework/operator-lib v0.1.0
go: downloading github.com/hashicorp/hcl v1.0.0
go: downloading github.com/rubenv/sql-migrate v0.0.0-20200616145509-8d140a17f351
go: downloading github.com/lib/pq v1.7.0
go: downloading github.com/kr/text v0.1.0
go: downloading github.com/spf13/cast v1.3.1
go: downloading github.com/google/gofuzz v1.1.0
go: downloading github.com/containerd/containerd v1.3.4
go: downloading github.com/docker/docker v1.4.2-0.20200203170920-46ec8731fbce
go: downloading github.com/nxadm/tail v1.4.4
go: downloading github.com/mitchellh/copystructure v1.0.0
go: downloading github.com/onsi/gomega v1.10.1
go: downloading github.com/markbates/inflect v1.0.4
go: downloading golang.org/x/lint v0.0.0-20191125180803-fdd1cda4f05f
go: downloading golang.org/x/sys v0.0.0-20200625212154-ddb9806d33ae
go: downloading github.com/gophercloud/gophercloud v0.1.0
go: downloading github.com/gogo/protobuf v1.3.1
go: downloading github.com/docker/cli v0.0.0-20200130152716-5d0cf8839492
go: downloading github.com/cespare/xxhash v1.1.0
go: downloading github.com/cespare/xxhash/v2 v2.1.1
go: downloading google.golang.org/protobuf v1.25.0
go: downloading k8s.io/klog v1.0.0
go: downloading github.com/cyphar/filepath-securejoin v0.2.2
go: downloading golang.org/x/net v0.0.0-20200625001655-4c5254603344
go: downloading github.com/prometheus/procfs v0.0.11
go: downloading golang.org/x/tools v0.0.0-20200403190813-44a64ad78b9b
go: downloading github.com/jmoiron/sqlx v1.2.0
go: downloading github.com/magiconair/properties v1.8.0
go: downloading github.com/prometheus/common v0.9.1
go: downloading github.com/evanphx/json-patch v4.5.0+incompatible
go: downloading gomodules.xyz/jsonpatch/v3 v3.0.1
go: downloading github.com/davecgh/go-spew v1.1.1
go: downloading google.golang.org/grpc v1.30.0
go: downloading github.com/golang/groupcache v0.0.0-20190702054246-869f871628b6
go: downloading golang.org/x/oauth2 v0.0.0-20190604053449-0f29369cfe45
go: downloading gomodules.xyz/orderedmap v0.1.0
go: downloading github.com/mattn/go-sqlite3 v1.10.0
go: downloading github.com/go-logr/zapr v0.1.0
go: downloading github.com/docker/distribution v2.7.1+incompatible
go: downloading github.com/golang-migrate/migrate/v4 v4.6.2
go: downloading github.com/xeipuuv/gojsonschema v1.2.0
go: downloading github.com/google/go-cmp v0.5.0
go: downloading github.com/go-openapi/strfmt v0.19.3
go: downloading github.com/opencontainers/runc v0.1.1
go: downloading github.com/docker/go-connections v0.4.0
go: downloading github.com/spf13/pflag v1.0.5
go: downloading github.com/opencontainers/go-digest v1.0.0
go: downloading gotest.tools v2.2.0+incompatible
go: downloading github.com/prometheus/client_model v0.2.0
go: downloading github.com/Shopify/logrus-bugsnag v0.0.0-20171204204709-577dee27f20d
go: downloading github.com/phayes/freeport v0.0.0-20180830031419-95f893ade6f2
go: downloading go.uber.org/multierr v1.3.0
go: downloading github.com/bugsnag/bugsnag-go v1.5.3
go: downloading github.com/Masterminds/squirrel v1.4.0
go: downloading golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9
go: downloading github.com/gobuffalo/envy v1.7.1
go: downloading golang.org/x/mod v0.2.0
go: downloading golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e
go: downloading gopkg.in/gorp.v1 v1.7.2
go: downloading github.com/spf13/cobra v1.0.0
go: downloading github.com/opencontainers/image-spec v1.0.2-0.20190823105129-775207bd45b6
go: downloading gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15
go: downloading github.com/docker/docker-credential-helpers v0.6.3
go: downloading github.com/joho/godotenv v1.3.0
go: downloading github.com/otiai10/copy v1.2.0
go: downloading github.com/beorn7/perks v1.0.1
go: downloading github.com/DATA-DOG/go-sqlmock v1.4.1
go: downloading github.com/Masterminds/sprig/v3 v3.1.0
go: downloading go.mongodb.org/mongo-driver v1.1.2
go: downloading github.com/exponent-io/jsonpath v0.0.0-20151013193312-d6023ce2651d
go: downloading github.com/gosuri/uitable v0.0.4
go: downloading github.com/docker/libtrust v0.0.0-20160708172513-aabc10ec26b7
go: downloading github.com/bshuster-repo/logrus-logstash-hook v0.4.1
go: downloading github.com/mxk/go-flowrate v0.0.0-20140419014527-cca7078d478f
go: downloading gomodules.xyz/jsonpatch/v2 v2.0.1
go: downloading github.com/mitchellh/mapstructure v1.1.2
go: downloading github.com/gorilla/handlers v1.4.2
go: downloading gopkg.in/inf.v0 v0.9.1
go: downloading k8s.io/kube-openapi v0.0.0-20200410145947-61e04a5be9a6
go: downloading github.com/inconshreveable/mousetrap v1.0.0
go: downloading github.com/asaskevich/govalidator v0.0.0-20200428143746-21a406dcc535
go: downloading google.golang.org/genproto v0.0.0-20200701001935-0939c5918c31
go: downloading github.com/pmezard/go-difflib v1.0.0
go: downloading github.com/kr/pretty v0.1.0
go: downloading github.com/containerd/continuity v0.0.0-20200413184840-d3ef23f19fbb
go: downloading github.com/go-openapi/validate v0.19.5
go: downloading github.com/Masterminds/semver/v3 v3.1.0
go: downloading go.etcd.io/bbolt v1.3.4
go: downloading github.com/fatih/color v1.7.0
go: downloading github.com/gorilla/mux v1.7.3
go: downloading github.com/lann/builder v0.0.0-20180802200727-47ae307949d0
go: downloading github.com/google/uuid v1.1.1
go: downloading github.com/Masterminds/goutils v1.1.0
go: downloading github.com/xeipuuv/gojsonreference v0.0.0-20180127040603-bd5ef7bd5415
go: downloading github.com/deislabs/oras v0.8.1
go: downloading github.com/gofrs/uuid v3.3.0+incompatible
go: downloading github.com/rogpeppe/go-internal v1.4.0
go: downloading sigs.k8s.io/kustomize v2.0.3+incompatible
go: downloading sigs.k8s.io/structured-merge-diff/v3 v3.0.0
go: downloading k8s.io/apiserver v0.18.8
go: downloading rsc.io/letsencrypt v0.0.3
go: downloading github.com/mitchellh/reflectwalk v1.0.0
go: downloading github.com/bitly/go-simplejson v0.5.0
go: downloading github.com/containerd/ttrpc v1.0.1
go: downloading github.com/Azure/go-autorest v13.3.2+incompatible
go: downloading github.com/huandu/xstrings v1.3.1
go: downloading github.com/Azure/go-autorest/autorest v0.9.0
go: downloading github.com/gobuffalo/packr/v2 v2.7.1
go: downloading go.uber.org/tools v0.0.0-20190618225709-2cfd321de3ee
go: downloading github.com/docker/go-units v0.4.0
go: downloading github.com/go-openapi/swag v0.19.5
go: downloading github.com/BurntSushi/toml v0.3.1
go: downloading github.com/Microsoft/hcsshim v0.8.9
go: downloading github.com/garyburd/redigo v1.6.0
go: downloading github.com/mattn/go-isatty v0.0.8
go: downloading go.uber.org/atomic v1.5.0
go: downloading github.com/go-openapi/spec v0.19.3
go: downloading github.com/gregjones/httpcache v0.0.0-20180305231024-9cad4c3443a7
go: downloading github.com/docker/go-metrics v0.0.1
go: downloading github.com/matttproud/golang_protobuf_extensions v1.0.1
go: downloading github.com/json-iterator/go v1.1.10
go: downloading github.com/Azure/go-autorest/autorest/mocks v0.2.0
go: downloading github.com/cpuguy83/go-md2man v1.0.10
go: downloading github.com/kardianos/osext v0.0.0-20190222173326-2bc1f35cddc0
go: downloading github.com/cpuguy83/go-md2man/v2 v2.0.0
go: downloading github.com/mailru/easyjson v0.7.0
go: downloading github.com/sergi/go-diff v1.0.0
go: downloading github.com/Microsoft/go-winio v0.4.15-0.20190919025122-fc70bd9a86b5
go: downloading github.com/yvasiyarov/gorelic v0.0.7
go: downloading gopkg.in/yaml.v2 v2.3.0
go: downloading github.com/lann/ps v0.0.0-20150810152359-62de8c46ede0
go: downloading google.golang.org/appengine v1.6.5
go: downloading github.com/liggitt/tabwriter v0.0.0-20181228230101-89fcab3d43de
go: downloading github.com/mattn/go-colorable v0.1.2
go: downloading github.com/gobuffalo/packd v0.3.0
go: downloading github.com/modern-go/reflect2 v1.0.1
go: downloading github.com/yvasiyarov/go-metrics v0.0.0-20150112132944-c25f46c4b940
go: downloading github.com/go-openapi/runtime v0.19.4
go: downloading github.com/bugsnag/panicwrap v1.2.0
go: downloading gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7
go: downloading cloud.google.com/go v0.38.0
go: downloading github.com/Azure/go-autorest/logger v0.1.0
go: downloading honnef.co/go/tools v0.0.1-2019.2.3
go: downloading github.com/go-sql-driver/mysql v1.4.1
go: downloading github.com/mattn/go-runewidth v0.0.4
go: downloading github.com/gobwas/glob v0.2.3
go: downloading github.com/russross/blackfriday v1.5.2
go: downloading github.com/xeipuuv/gojsonpointer v0.0.0-20180127040702-4e3ac2762d5f
go: downloading github.com/yvasiyarov/newrelic_platform_go v0.0.0-20160601141957-9c099fbc30e9
go: downloading github.com/hashicorp/golang-lru v0.5.4
go: downloading github.com/ziutek/mymysql v1.5.4
go: downloading go.opencensus.io v0.22.2
go: downloading github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd
go: downloading github.com/gobuffalo/logger v1.0.1
go: downloading github.com/russross/blackfriday/v2 v2.0.1
go: downloading github.com/Azure/go-autorest/tracing v0.5.0
go: downloading sigs.k8s.io/apiserver-network-proxy/konnectivity-client v0.0.7
go: downloading github.com/emicklei/go-restful v2.9.5+incompatible
go: downloading github.com/peterbourgon/diskv v2.0.1+incompatible
go: downloading github.com/golang/mock v1.3.1
go: downloading golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543
go: downloading github.com/go-openapi/jsonpointer v0.19.3
go: downloading github.com/go-openapi/analysis v0.19.5
go: downloading github.com/google/btree v1.0.0
go: downloading github.com/shurcooL/sanitized_anchor_name v1.0.0
go: downloading github.com/go-openapi/errors v0.19.2
go: downloading github.com/otiai10/mint v1.3.1
go: downloading github.com/go-openapi/jsonreference v0.19.3
go: downloading github.com/morikuni/aec v1.0.0
go: downloading k8s.io/component-base v0.18.8
go: downloading k8s.io/klog/v2 v2.0.0
go: downloading github.com/docker/go-events v0.0.0-20190806004212-e31b211e4f1c
go: downloading github.com/PuerkitoBio/purell v1.1.1
go: downloading github.com/containerd/cgroups v0.0.0-20190919134610-bf292b21730f
go: downloading github.com/opencontainers/runtime-spec v0.1.2-0.20190507144316-5b71a03e2700
go: downloading github.com/Azure/go-autorest/autorest/adal v0.5.0
go: downloading github.com/bmizerany/assert v0.0.0-20160611221934-b7ed37b82869
go: downloading github.com/PuerkitoBio/urlesc v0.0.0-20170810143723-de5bf2ad4578
go: downloading github.com/tidwall/pretty v1.0.0
go: downloading github.com/Azure/go-ansiterm v0.0.0-20170929234023-d6e3b3328b78
go: downloading github.com/containerd/typeurl v0.0.0-20180627222232-a93fcdb778cd
go: downloading github.com/otiai10/curr v1.0.0
go: downloading github.com/go-openapi/loads v0.19.4
go: downloading github.com/dgrijalva/jwt-go v3.2.0+incompatible
go: downloading github.com/go-stack/stack v1.8.0
go: downloading github.com/Azure/go-autorest/autorest/date v0.1.0
go: downloading github.com/mitchellh/go-wordwrap v1.0.0
go: downloading github.com/MakeNowJust/heredoc v0.0.0-20170808103936-bb23615498cd
go: downloading github.com/docker/spdystream v0.0.0-20160310174837-449fdfce4d96
go: downloading github.com/elazarl/goproxy v0.0.0-20180725130230-947c36da3153
root@raspberrypi:~/operator-sdk# make tidy ^C
root@raspberrypi:~/operator-sdk# mke in^C
root@raspberrypi:~/operator-sdk# make install
```


## build command not found

Using master branch

```sh
root@raspberrypi:~/vault-secrets-operator# make build
operator-sdk build --go-build-args "-ldflags -X=github.com/ricoberger/vault-secrets-operator/version.BuildInformation=1.8.1,ca8429953e438f1e945a84b508447ddc4e639019,master,root,2020-10-26@00:51:52" vault-secrets-operator:1.8.1
Error: unknown command "build" for "operator-sdk"
Run 'operator-sdk --help' for usage.
FATA[0000] unknown command "build" for "operator-sdk"   
make: *** [Makefile:12: build] Error 1

```

Using different version of docs now:

https://v0-19-x.sdk.operatorframework.io/docs/new-cli/operator-sdk_build/


Probably related to Operator SDK new cli.


```sh
root@raspberrypi:~/vault-secrets-operator# make build
operator-sdk build --go-build-args "-ldflags -X=github.com/ricoberger/vault-secrets-operator/version.BuildInformation=1.8.1,ca8429953e438f1e945a84b508447ddc4e639019,master,root,2020-10-26@01:14:00" vault-secrets-operator:1.8.1
[Deprecation Notice] Operator SDK has a new CLI and project layout that is aligned with Kubebuilder.
See `operator-sdk init -h` and the following doc on how to scaffold a new project:
https://v0-19-x.sdk.operatorframework.io/docs/golang/quickstart/
To migrate existing projects to the new layout see:
https://sdk.operatorframework.io/docs/building-operators/golang/project_migration_guide/


go: downloading github.com/operator-framework/operator-sdk v0.18.0
go: downloading golang.org/x/net v0.0.0-20200301022130-244492dfa37a
go: downloading github.com/hashicorp/vault/api v1.0.4
go: downloading github.com/golang/protobuf v1.3.2
go: downloading github.com/hashicorp/vault/sdk v0.1.13
go: downloading github.com/hashicorp/go-multierror v1.0.0
go: downloading github.com/hashicorp/go-retryablehttp v0.5.4
go: downloading github.com/hashicorp/go-rootcerts v1.0.1
go: downloading gopkg.in/square/go-jose.v2 v2.3.1
go: downloading github.com/hashicorp/errwrap v1.0.0
go: downloading sigs.k8s.io/structured-merge-diff v1.0.2
go: downloading github.com/golang/snappy v0.0.1
go: downloading github.com/hashicorp/go-cleanhttp v0.5.1
go: downloading github.com/pierrec/lz4 v2.0.5+incompatible
go: downloading github.com/hashicorp/go-sockaddr v1.0.2
go: downloading golang.org/x/crypto v0.0.0-20200414173820-0848c9571904
go: downloading github.com/google/go-cmp v0.4.0
go: downloading golang.org/x/sys v0.0.0-20200202164722-d101bd2416d5
go: downloading github.com/ryanuber/go-glob v1.0.0
go: downloading golang.org/x/text v0.3.2
INFO[0133] Building OCI image vault-secrets-operator:1.8.1
Sending build context to Docker daemon  36.69MB
Step 1/7 : FROM registry.access.redhat.com/ubi7/ubi-minimal:latest
latest: Pulling from ubi7/ubi-minimal
no matching manifest for linux/arm/v7 in the manifest list entries
FATA[0140] Failed to build image vault-secrets-operator:1.8.1: failed to exec []string{"docker", "build", "-f", "build/Dockerfile", "-t", "vault-secrets-operator:1.8.1", "."}: exit status 1
make: *** [Makefile:12: build] Error 1
root@raspberrypi:~/vault-secrets-operator#

```

UBI redhat based docker image
https://catalog.redhat.com/software/containers/ubi7/ubi/5c3592dcd70cc534b3a37814?container-tabs=dockerfile


Searching for armv7 Centos Image


```sh
root@raspberrypi:~/vault-secrets-operator# make build
operator-sdk build --go-build-args "-ldflags -X=github.com/ricoberger/vault-secrets-operator/version.BuildInformation=1.8.1,ca8429953e438f1e945a84b508447ddc4e639019,master,root,2020-10-26@01:25:47" vault-secrets-operator:1.8.1
[Deprecation Notice] Operator SDK has a new CLI and project layout that is aligned with Kubebuilder.
See `operator-sdk init -h` and the following doc on how to scaffold a new project:
https://v0-19-x.sdk.operatorframework.io/docs/golang/quickstart/
To migrate existing projects to the new layout see:
https://sdk.operatorframework.io/docs/building-operators/golang/project_migration_guide/

INFO[0009] Building OCI image vault-secrets-operator:1.8.1
Sending build context to Docker daemon  36.69MB
Step 1/7 : FROM arm32v7/centos
latest: Pulling from arm32v7/centos
193bcbf05ff9: Pull complete
Digest: sha256:9fd67116449f225c6ef60d769b5219cf3daa831c5a0a6389bbdd7c952b7b352d
Status: Downloaded newer image for arm32v7/centos:latest
 ---> 8c52f2d0416f
Step 2/7 : ENV OPERATOR=/usr/local/bin/vault-secrets-operator     USER_UID=1001     USER_NAME=vault-secrets-operator
 ---> Running in a09a677958a5
Removing intermediate container a09a677958a5
 ---> 7c3b2fa1fb68
Step 3/7 : COPY build/_output/bin/vault-secrets-operator ${OPERATOR}
 ---> c5390a7c8c84
Step 4/7 : COPY build/bin /usr/local/bin
 ---> f9c11552e821
Step 5/7 : RUN  /usr/local/bin/user_setup
 ---> Running in 8740cba09e93
+ mkdir -p /root
+ chown 1001:0 /root
+ chmod ug+rwx /root
+ chmod g+rw /etc/passwd
+ rm /usr/local/bin/user_setup
Removing intermediate container 8740cba09e93
 ---> 3edf0ca7d444
Step 6/7 : ENTRYPOINT ["/usr/local/bin/entrypoint"]
 ---> Running in fd07617cd1f5
Removing intermediate container fd07617cd1f5
 ---> b7889f50a799
Step 7/7 : USER ${USER_UID}
 ---> Running in 0ce7ba61b476
Removing intermediate container 0ce7ba61b476
 ---> 63ff7340f9f6
Successfully built 63ff7340f9f6
Successfully tagged vault-secrets-operator:1.8.1
INFO[0062] Operator build complete.                     
root@raspberrypi:~/vault-secrets-operator#
```


## Docker Tag && push

```sh
root@raspberrypi:~/vault-secrets-operator# docker tag vault-secrets-operator:1.8.1 mwillemsma/vault-secrets-operator-arm:1.8.1


root@raspberrypi:~/vault-secrets-operator# docker push mwillemsma/vault-secrets-operator-arm:1.8.1
The push refers to repository [docker.io/mwillemsma/vault-secrets-operator-arm]
7e8af6ca6c50: Pushed
70aac1bdac4f: Pushed
1504c5dab60e: Pushed
1cb2a587a49f: Mounted from arm32v7/centos
1.8.1: digest: sha256:65bcfd16eaef01cf423ba9a75354d84193ade51b12b3786241cf5432b49b4095 size: 1155

```
