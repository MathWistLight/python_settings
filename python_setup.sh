#!/bin/bash -eu
# coding: utf-8

file_bef="before_setup_`date "+%Y%m%d"`"
file_aft="aft_setup_`date "+%Y%m%d"`"

workspace="<workspace dir>" #作業対象
envname="<virtualenv name>" #環境名
pythonpath=`which python3` #導入予定のpython

echo "****************************"
echo "環境名：${envname}"
echo "Pythoバージョン：`${pythonpath} --version`"
echo "****************************\n"

# 作業対象ディレクトリへの移動
cd ${workspace}
pwd

# 仮想環境作成
echo "仮想環境${envname}を作成"
source "/usr/local/bin/virtualenvwrapper.sh"
mkvirtualenv ${envname} --python=${pythonpath}

# パッケージ確認（インストール前）
echo "インストール前差分取得"
pip freeze > before_setup_`date "+%Y%m%d"`

# パッケージインストール
echo "パッケージインストールを開始"
pip install numpy matplotlib scikit-learn gensim pandas scipy seaborn emoji jupyterlab django pylint flake8 autopep8 # pip経由でのインストール
## pynderのインストール
git clone https://github.com/charliewolf/pynder.git
cd pynder
python setup.py install
cd ..
## pyknpのインストール
git clone https://github.com/ku-nlp/pyknp.git
cd pyknp
python setup.py install
cd ..

# パッケージ確認（インストール後）
pip freeze > aft_setup_`date "+%Y%m%d"`

# 差分チェック
diff ${file_bef} ${file_aft} > ${envname}_`date "+%Y%m%d"`

# 後片付け
ls -la
echo "ゴミ掃除開始"
rm -rf pynder pyknp
rm -f ${file_bef} ${file_aft}
echo "ゴミ掃除終了"
ls -la
