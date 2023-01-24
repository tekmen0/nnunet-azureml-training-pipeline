FROM python:3.8.6

EXPOSE 4321/tcp

ENV TZ=America/Chicago \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    CUDA_DEVICE_ORDER=PCI_BUS_ID \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility \
    nnUNet_n_proc_DA=32 \
    nnUNet_raw_data_base="/input" \
    nnUNet_preprocessed="/preprocessed" \
    nnUNet_master_port=4321 \
    RESULTS_FOLDER="/output" \
    HDF5_USE_FILE_LOCKING=FALSE 

WORKDIR /root

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata && \
    ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone && \
    apt-get remove -y linux-libc-dev && \ 
    apt-get install -y \
        git \
        curl \
        graphviz \
        libx11-6 \
        ca-certificates && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /input /output /preprocessed
    
RUN apt-get update \
    python3 \
    python3-pip \
    && apt-get clean \
    && apt-get autoremove \

RUN pip install torch==1.7.1+cpu torchvision==0.8.2+cpu torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html


RUN conda update -y conda && \
    python -m pip install -U pip && \
    python -m pip install nnunet && \
    ! pip install -U python-dateutil && \
    python -m pip install -U git+https://github.com/FabianIsensee/hiddenlayer.git@more_plotted_details#egg=hiddenlayer && \
    conda clean -ya && \
    rm -rf $(python -m pip cache dir)
    ! pip install gdown
    
