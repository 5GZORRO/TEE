# Trusted Execution Environment based on Intel SGX

## Introduction
Support for running specific 5GZORRO components in an [Intel SGX](https://www.intel.com/content/www/us/en/architecture-and-technology/software-guard-extensions.html) [enclave](https://www.intel.com/content/dam/develop/external/us/en/documents/overview-of-intel-sgx-enclave-637284.pdf) using [SCONE](https://sconedocs.github.io/) framework. This allow strong guarantees of:
- Software is executing untampered in a defined context (integrity), since there’s a hash of the whole execution context (code, starting conditions, etc). That hash is signed by Intel.
- Confidentiality from other processes in the same system: enclaves are isolated, have encrypted memory regions, etc. 

Both of previous guarantees are applicable to the case of remote hardware controlled by an adversary or an untrusted service provider (remote attestation)

Components that are specially important security wise and there’s something to be gained by protecting them from an adversary with full control of the OS can/should be run in TEE.

### Caveats 
- It is not transparent to the applications, they need to be designed and implemented with SGX in mind
    - SCONE framework helps with this by allowing standalone applications not designed with SGX in mind to run on SGX
- It does NOT make an application itself more secure in any way. This is about the TCB (Trusted Computing Base): reducing it, or having one in remote hardware
it is not a silver bullet, and is susceptible to side-channel attacks / other vulnerabilities when the adversary has access to the hardware (but these are sophisticated / expensive)
- Might incur a performance penalty that may go from light’ish ~10% to severe (100%+)


## Prerequisites

#### System Requirements
* Intel CPU with support for the Intel SGX Extensions 

### Software dependecies
* Linux OS for running the scripts
* Installed Kubernetes cluster with Helm for deploying the application

### 5GZORRO Module dependencies
Dependencies are the same of the component if not deployed on TEE

## Installation

## How to run your app on Intel SGX

![image](https://user-images.githubusercontent.com/98831473/177827102-737e3d62-eeaa-4fb5-b414-0ccd4acc2759.png)
1. Create GitLab account 
   
   - Please register a free account at [Sign up · GitLab](https://gitlab.scontain.com/users/sign_up).
   
   - You need to confirm your email and, we will grant you - typically within a few
     hours - access to the community edition.

2. Create token
   
   - After you registered an account, you can create an access token for docker login as follows: You can create a [Sign in · GitLab](https://gitlab.scontain.com/-/profile/personal_access_tokens) by
     
     - selecting a name of the token, e.g., docker_token
     - selecting scope read_registry and then
     - pressing button create
        personal access token.

3. Login to the Registry
   
   ```bash
   docker
   login registry.scontain.com:5050
   ```

4. Pull required images
   
   ```bash
   docker
   pull registry.scontain.com:5050/sconecuratedimages/crosscompilers:alpine
   
   docker
   pull
   registry.scontain.com:5050/sconecuratedimages/community-edition-sconify-image:latest
   ```

5. Build your image
   
   - Make sure the entrypoint is a single binary, i.e. no scripts
   - Ensure the binary to be called exists and is not a link, e.g. `gunicorn` should be `python -m gunicorn…`

6. Get SGX Device
   
   - Assume `/dev/isgx` or search with other methods
   
   - The following script, as provided by Scone, does not currently work
     
     ```bash
     function determine_sgx_device {
         export SGXDEVICE="/dev/sgx"
         export MOUNT_SGXDEVICE="--device=/dev/sgx"
         if [[ ! -e "$SGXDEVICE" ]] ; then
             export SGXDEVICE="/dev/isgx"
             export MOUNT_SGXDEVICE="--device=/dev/isgx"
             if [[ ! -c "$SGXDEVICE" ]] ; then
                 echo "Warning: No SGX device found! Will run in SIM mode." > /dev/stderr
                 export MOUNT_SGXDEVICE=""
                 export SGXDEVICE=""
             fi
         fi
     }
     
     determine_sgx_device
     echo $SGXDEVICE
     ```

7. Sconify the TEEManager
   
   - Using `sconify_image` (from <[Sconify Image SE - Confidential Computing](https://sconedocs.github.io/ee_sconify_image/)>)
     
     - sconify_image is a command line tool within a SCONE image that enables the sconification of native images without detailed knowledge of the
       SCONE framework. 
     
     - sconify_image transforms a native container image to an encrypted SCONE-enabled image in one step. We call this transformation sconification. 
     
     - These SCONE-enabled images execute their service within
       an SGX enclave using the SCONE runtime. 
     
     - In particular, the features of sconify_image are:
       
       - Sconification of the native image binary such that the execution of the sconified binary is performed within an SGX enclave
       
       - Encryption and integrity protection of native image files: giving access to the sconified binary only after it is [attested by the SCONE platform](https://sconedocs.github.io/advantages/)
       
       - Creation of a [SCONE policy](https://sconedocs.github.io/CAS_session_lang_0_3/) using sensible defaults (e.g., including native image environment variables and working directory), and with options to customize to use additional features of the SCONE policy language (e.g., SCONE shared volumes, shared secrets, injected files) - ensuring only the sconified binary can access the secured resources, and usage of all these features
          with only a single command - enabling an easy integration into existing
          CI/CD workflows.
   
   - Example:
     
     ```bash
     REGISTRY=registry.cbr.ubiwhere.com
     
     docker run --rm --device="/dev/isgx" \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -v ${PWD}/../docker/config.json:/root/.docker/config.json \
     -v ${PWD}/sconification/build-resources:/build-resources \
     -v ${PWD}/sconification/helm:/sconify-helm \
     -v ${PWD}/../cas/:/root/.cas/ \
     registry.scontain.com:5050/sconecuratedimages/community-edition-sconify-image:latest \
     sconify_image --name=tee-manager \
     --from=${REGISTRY}/tee-manager \
     --to=${REGISTRY}/tee-manager-encrypted:latest \
     --cas=5-7-0.scone-cas.cf \
     --cli=registry.scontain.com:5050/sconecuratedimages/sconecli:sconify-image \
     --cas-debug  \
     --binary="/usr/bin/python3.9" -v \
     --disable-session-upload --allow-debug-mode --allow-tcb-vulnerabilities \
     --service-name="tee-manager" --name="tee-manager" \
     --namespace="SDJLFSeer9w-UW-ZORRO" \
     --k8s-helm-workload-type=deployment \
     --identity="/root/.cas/config.json" \
     --k8s-helm-set="useSGXDevPlugin=disabled" \
     --k8s-helm-set="scone.log=DEBUG" \
     --k8s-helm-set="imagePullSecrets[0].name=uw" \
     --k8s-helm-set="imagePullPolicy=IfNotPresent" \
     --push-image \
     --plain="/tee-manager" \
     -x --dlopen=2 --stack=4M --heap=1G
     ```
   
   - Expected end of output:
     
     ```bash
     + PROGRESS_CURRENT_STATE=finished
     + exit 0
     ```

8. Register on the CAS on each build
   
   - Launch scone CLI
     
     ```bash
     docker
     run -v ${PWD}/../cas/:/root/.cas/ -it  registry.scontain.com:5050/sconecuratedimages/sconecli:latest
     ```
   
   - Upload session to CAS
     
     ```bash
     scone session create session-tee-manager.yaml
     ```
   
   - Ensure you save the HASH!
     
     ```
     506df4b1b64227be48d761b4e7873ccaf83db9b5133a973f2b4e2edde5671c4c
     ```

9. Install Helm Charts
   
   ```bash
   cd sconification/helm/tee-manager
   helm -n scone uninstall tee-manager
   helm -n scone install -f values.yaml tee-manager .
   cd -
   ```

10. You should see:
    
    ```bash
    kubectl -n scone logs tee-manager-sconify-tee-manager-5b5d7bfff5-rvjst sconeap
    
    ... 
    
    [SCONE|DEBUG] tools/libsgx/src/builder.c:810:finalize_builder(): enclave base: 0x1000000000
    [SCONE|DEBUG] tools/libsgx/src/layout.c:791:scone_enclave_create_layout(): enclave size: 2147483648
    
    ...
    
    [SCONE|DEBUG] scone_rrt::implementation::eai src/implementation/eai.rs:256:Successfully attested at CAS
    ```

11. Debug if necessary:
    
    ```bash
    kubectl -n scone describe Pods tee-manager-sconify-tee-manager-5b5d7bfff5-rvjst
    kubectl -n scone exec -it pod isbp-sconify-isbp-677c6bc5d5-flr46 -- sh
    ```


## Maintainers
**Carlos Jorge** - *Initial design* - cjorge@ubiwhere.com

**Pedro Teixeira** - *Final deployment and maintenance* - pteixeira@ubiwhere.com

## License
This module is distributed under *if_you_pay_you_can_use_it*_LICENSE terms
