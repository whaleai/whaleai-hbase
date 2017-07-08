#!/bin/sh
# Author:wangxiaolei 王小雷
# Blog: http://blog.csdn.net/dream_an
# Github: https://github.com/wangxiaoleiai
# Date: 201707
# Organization: https://github.com/whaleai

installed=false
  if [ -f /etc/profile.d/hbase-$HBASE_VERSION.sh ]; then
      source /etc/profile.d/hbase-$HBASE_VERSION.sh
      source $HBASE_HOME/etc/hbase/hbase-env.sh
      installed=true
  fi
create_config()
{
	local filename=

        case $1 in
            '')    echo $"$0: Usage: create_config --file"
                   return 1;;
            --file)
	           filename=$2
	           ;;
        esac

python - <<END
from xml.etree import ElementTree
from xml.etree.ElementTree import Element
conf = Element('configuration')
conf_file = open("$filename",'w')
conf_file.write(ElementTree.tostring(conf))
conf_file.close()
END
	write_file $filename

}

put_config()
{
	local filename= property= value=

        while [ "$1" != "" ]; do
        case $1 in
            '')    echo $"$0: Usage: put_config --file --property --value"
                   return 1;;
            --file)
                   filename=$2
                   shift 2
                   ;;
            --property)
                   property=$2
                   shift 2
                   ;;
            --value)
                   value=$2
                   shift 2
                   ;;
        esac
        done

	python - <<END
from xml.etree import ElementTree
from xml.etree.ElementTree import Element
from xml.etree.ElementTree import SubElement
def putconfig(root, name, value):
	for existing_prop in root.getchildren():
		if existing_prop.find('name').text == name:
			root.remove(existing_prop)
			break

	property = SubElement(root, 'property')
	name_elem = SubElement(property, 'name')
	name_elem.text = name
	value_elem = SubElement(property, 'value')
	value_elem.text = value
path = ''
if "$installed" == 'true':
	path = "$HADOOP_CONF_DIR" + '/'
conf = ElementTree.parse(path + "$filename").getroot()
putconfig(root = conf, name = "$property", value = "$value")
conf_file = open("$filename",'w')
conf_file.write(ElementTree.tostring(conf))
conf_file.close()
END

	write_file $filename
}

write_file()
{
	local file=$1

	xmllint --format "$file" > "$file".pp && mv "$file".pp "$file"
}

Author="#!/bin/sh
# Author:wangxiaolei 王小雷
# Blog: http://blog.csdn.net/dream_an
# Github: https://github.com/wangxiaoleiai
# Date: 201707
# Organization: https://github.com/whaleai
"
#Configuring Environment of hbase Daemons
HBaseEnv="
export HBASE_HOME=/opt/hbase-$HBASE_VERSION
export PATH=\$HBASE_HOME/bin:\$PATH
export HBASE_CONF_DIR="\$HBASE_HOME/conf"
export HBASE_CLASSPATH="\$HBASE_HOME/lib"
"
