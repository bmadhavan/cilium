#!/bin/bash
set -e

CILIUM_DS_TAG="k8s-app=cilium"
KUBE_SYSTEM_NAMESPACE="kube-system"
KUBECTL="/usr/bin/kubectl"

export GOPATH="/go/"

mkdir -p $GOPATH/src/github.com/cilium/
chmod 777 $GOPATH/ -R
rm -rf $GOPATH/src/github.com/cilium/cilium
sudo -u vagrant cp -rf /src $GOPATH/src/github.com/cilium/cilium

cd $GOPATH/src/github.com/cilium/cilium

if echo $(hostname) | grep "k8s" -q;
then
    if [[ "$(hostname)" == "k8s1" ]]; then
        make docker-image
        docker tag cilium/cilium k8s1:5000/cilium/cilium-dev
        docker push k8s1:5000/cilium/cilium-dev
        echo "Executing: $KUBECTL delete pods -n $KUBE_SYSTEM_NAMESPACE -l $CILIUM_DS_TAG"
        $KUBECTL delete pods -n $KUBE_SYSTEM_NAMESPACE -l $CILIUM_DS_TAG
    else
        echo "Not on master K8S node; no need to compile Cilium container"
    fi
else

    # symlink all go bins to /usr/bin so envoy can use them without
    # changing envoy's PATH to include $GOPATH/bin
    # Clean this once we move to the next ginkgo VM image
    sudo -E ln -s ${GOPATH}/bin/* /usr/local/bin

    sudo -u vagrant -H -E make PKG_BUILD=1
    make install
    mkdir -p /etc/sysconfig/
    cp -f contrib/systemd/cilium /etc/sysconfig/cilium
    for svc in $(ls -1 ./contrib/systemd/*.*); do
        cp -f "${svc}"  /etc/systemd/system/
        service=$(echo "$svc" | sed -E -n 's/.*\/(.*?).(service|mount)/\1.\2/p')
        echo "service $service"
        systemctl enable $service || echo "service $service failed"
        systemctl restart $service || echo "service $service failed to restart"
    done
    echo "running \"sudo adduser vagrant cilium\" "
    sudo adduser vagrant cilium
fi
