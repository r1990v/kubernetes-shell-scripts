#Expects partial namespace text.

serviceName=$1

counter=1
namespaceName=`kubectl get pods --all-namespaces -o wide | grep $serviceName | tr -s ' ' | cut -d ' ' -f1 | head -1`
numberOfPods=`kubectl get pods --all-namespaces -o wide | grep $serviceName | tr -s ' ' | cut -d ' ' -f2| wc -l`

nameOfPods=`kubectl get pods --all-namespaces -o wide | grep $serviceName | tr -s ' ' | cut -d ' ' -f2`

#nameOfPods=`kubectl get pods --all-namespaces -o wide | grep $serviceName | cut -d ' ' -f 4`
#if number of pods > 4, cut -d ' ' -f 7

echo 'Namespace Found: '$namespaceName;
echo 'Total number of pods running in the provided namespace: '$numberOfPods;
echo;


for nameOfPod in $nameOfPods;
do
  echo -ne 'pod '$counter'--------------------------------\n';
  echo -e 'Pod Name: '$nameOfPod;
  kubectl --namespace $namespaceName get pod $nameOfPod -o yaml | grep -A3 image | tail -n5 | head -1;
  kubectl --namespace $namespaceName get pod $nameOfPod -o yaml | grep -A5 limit | head -6;
  kubectl --namespace $namespaceName get pod $nameOfPod -o yaml | grep -A1 hostIP | head -1;
  counter=$(( counter + 1 ));
  echo '-------------------------------------';
  echo -e '\n';
done
