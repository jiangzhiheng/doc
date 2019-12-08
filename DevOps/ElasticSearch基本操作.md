1. 倒排索引

   `ElasticSearch`使用一宗称为倒排索引的结构,它适用于快速的全文搜索，一个倒排索引由文档中所有不重复词的列表构成，对于其中每个词，有一个包含它的文档列表

   示例：

   - 假设文档集合包含五个文档，最左端对应文档编号，右端文档内容
   - 中文和英文等语言不同，单词之间没有明确分隔符号，所以首先要用分词系统将文档分隔成单词序列，这样没个文档就转化为由单词序列构成的数据流，为了系统后续处理方便，需要对每个不同单词赋予唯一的单词编号，同时记录下哪些文档包含这些单词，即可得到最简单的倒排索引
   - 索引系统还可记录单词频率信息(TF)
   - 倒排列表中还可以记录单词在某个文档出现的位置信息

   使用标准化规则(Normalization):

   - 建立倒排索引的时候，ES会对拆分出的每个单词进行相应的处理，以提升后面搜索的时候能够搜索到相关联的文档的概率

2. 分词器

   分词器：从一串文本中切分出一个一个的词条，并对每个词条进行标准化

   包括三部分：

   - `character filter`：分词之前的预处理，过滤掉HTML标签，特殊符号转换等
   - `tokenizer`：分词
   - `token filter`：标准化

   内置分词器

   - `standard分词器`：(默认的)会将词汇单元转换成小写形式，并去除停用词和标点符号，支持中文采用的方法为单字切分
   - `simple分词器`：通过非字母来分割文本信息，然后将词汇单元统一为小写格式，去掉数字类型的字符
   - `Whitespace分词器`：仅仅是去除空格，不支持中文
   - `language分词器`：特定语言的分词器，不支持中文

3. 使用`ElasticSearch API `实现CRUD（以下操作都在`kibana Dev Tools`中执行）

   添加索引

   ```
   PUT /lib/
   {
       "settings":{
   		"index":{
   			"number_of_shards":3,
   			"number_of_replicas":0
   		}
       }  
   }
   ```

   查看索引信息

   ```json
   GET /lib/_settings    //查看lib的信息
   GET _all/_settings        //查看所有索引的信息
   ```

   添加文档

   1）指定文档ID用PUT方法

   ```json
   PUT /lib/user/1
   {
   "first_name":	"Jane",
   "last_name":	"Smith",
   "age":			32,
   "about":		"I like to collect rock albums",
   "interests":	"music"
   }
   //user:  type 相当于mysql中的一个table
   //1 ：文档ID  相当于表中的一行信息
   ```

   2）不指定文档ID用

   ```json
   POST /lib/user/
   {
   "first_name":	"Douglas",
   "last_name":	"Fir",
   "age":			23,
   "about":		"I like to build cabinets",
   "interests":	["forestry"]
   }
   ```

   查询文档

   ```json
   GET /lib/user/1   //获取制定文档的全部信息
   //1:指定文档ID
   GET /lib/user/1?_source=last_name,about    //查询文档中指定的字段
   ```

   更新文档

   1）用相同ID的文档内容PUT覆盖

   2）用POST方法修改文档中的信息

   ```json
   POST /lib/user/1/_update
   {
       "doc":{
   		"age":33
       }
   }
   ```

   删除文档

   ```json
   DELETE /lib/user/1  //删除文档
   DELETE lib2		   //删除索引
   ```

4. 批量获取文档

   使用es提供的`Multi Get API`：

   使用`Multi Get API`可以通过索引名，类型名，文档ID一次得到一个文档集合，文档可以来自同一个索引库，也可以来自不同索引库

   使用`curl`命令(在命令行中操作)：

   ```json
   curl 'http://192.168.1.130:9200/_mget' -d '{
       "docs":[
           .....
       ] 
   }'
   ```

   使用kibana客户端操作：

   ```json
   GET /_mget
   {
     "docs":[
       {
         "_index":"lib",
         "_type":"user",
         "_id":1
       },
           {
         "_index":"lib",
         "_type":"user",
         "_id":2
       },
           {
         "_index":"lib",
         "_type":"user",
         "_id":3
       }
       ]
   }
   ```

   指定具体的字段

   ```json
   GET /_mget
   {
     "docs":[
       {
         "_index":"lib",
         "_type":"user",
         "_id":1,
         "_source":["age","interests"]  
       },
           {
         "_index":"lib",
         "_type":"user",
         "_id":3
       }
       ]
   }
   ```

   对于同索引，同type下的文档，可以简写为如下形式

   ```json
   GET /lib/user/_mget
   {
       "docs":[
           {
               "_id":1
           },
           {
               "_type":"user",
               "_id":2
           }
       ]
   }
   ```

   简化形式2：

   ```json
   GET /lib/user/_mget
   {
       "ids":["1","2"]
   }
   ```

5. 使用Bulk API实现批量操作

   bulk的格式：

   `{action:{metadata}}\n`

   `{requestbody}\n`

   `action`(行为)：

   - `create`：文档不存在时创建
   - `update`：更新文档
   - `index`：创建新文档或替换已有文档
   - `delete`：删除一个文档
   - `metadata`：`_index`,`_type`,`_id`

   create和index的区别：如果数据存在，使用create操作失败，会提示文档已经存在，使用index则可以成功

   示例

   `{"delete":{"_index":"lib","_type":"user","_id":"1"}}`

   批量添加：

   ```json
   POST /lib2/books/_bulk
   {"index":{"_id":1}}
   {"title":"Java","price":55}
   {"index":{"_id":2}}
   {"title":"TTML5","price":45}
   {"index":{"_id":3}}
   {"title":"PHP","price":35}
   {"index":{"_id":4}}
   {"title":"Python","price":50}
   ```

   ```json
   GET /lib2/book/_mget
   {
       "ids":["1","2","3","4"]
   }
   ```

   bulk会把将要处理的数据载入内存中，所以数据量是有限制的，最佳的数据量不是一个确定的数值，它取决于你的硬件，文档大小以及文档复杂性，你的索引以及搜索的负载

   一般建议是1000-5000个文档，大小建议是5-15MB，默认不能超过100M，可以在ES的配置文件中修改。

6. 版本控制

   `ElasticSearch`采用了乐观锁来保证数据的一致性，也就是说，当用户对`docunment`进行操作时，并不需要对该用户作加锁和解锁的操作，只需要指定要操作的版本即可，当版本号一致时，`ElasticSearch`会允许该操作顺利执行，而当版本号存在冲突时，`ElasticSearch`会提示冲突并抛出异常。

   `ElasticSearch`的版本号的取值范围是`1-(2^36-1)`

   内部版本控制：使用的是`_version`

   外部版本控制：`ElasticSearch`在处理外部版本号时会与对内部版本号的处理有些不同。它不再是检查`_version`是否与请求中指定的数值相同，而实检查`_version`是否比指定的数值小，如果请求成功，那么外部版本号就会存储到文档中的`_version`中。

   为了保持`_version`与外部版本控制的数据一致，使用`version_type=externel`

7. 什么是`Mapping`

   `Mapping`定义了type中每个字段的数据类型及这些字段该如何分词等相关属性

   查看ES中自动创建的`mapping`

   `GET /myindex/article/_mapping`

   创建索引的时候，可以预先定义字段的类型及相关属性，这样就能够把日期字段处理成日期，把数字字段处理成数字，把字符串字段处理成字符串值等。

   支持的数据类型：

   - 核心数据类型

     字符串：string类型包括

     - text：需要分词
     - keyword：不需要进行分词

     数字型：`long integer short byte double float`

     日期型：`date`

     布尔型：`boolean`

     二进制型：`binary`

   - 复杂数据类型

     数组类型

     - 字符串
     - 整形数组
     - 数组型数组
     - 对象数组

     对象类型：`_object_`用于单个JSON对象

     ```json
     PUT /lib5/person/1
     {
         "name":"Tom",
         "age":25,
         "birthday":"1993-12-3",
         "address":{
             "country":"china",
             "province":"guangdong",
             "city":"shenzhen"
         }
     }
     ```

     `GET /lib5/person/_mapping`

     嵌套类型：`_nested_`用于JSON数组

   - 地理位置类型

   - 特定类型

   Tips:

   - 日期和数字不分词，查询的时候需要精确查询

     `GET /myindex/article/_search?q=post_date:2019-12-7`

   支持的属性：

   - `"index":true`：//true 分词，false，不分词
   - `"analyzer":"ik"` ：//指定分词器
   - `"ignore_above":100`：//超过100个字符的文本，将会被忽略，不被索引
   - `"search_analyzer":"ik"`：//设置搜索时的分词器，默认跟`analyzer`是一致的

8. 基本查询（Query查询）

   1. 数据准备

      ```json
      //创建索引
      PUT /lib3 
      {
          "settings":{
              "number_of_shards":3,
      	    "number_of_replicas":0
          },
          "mappings":{
              "user":{
                  "properties":{
                      "name":{"type":"text"},
                      "address":{"type":"text"},
                      "age":{"type":"integer"},
                      "interests":{"type":"text"},
                  	"birthday":{"type":"date"}
                  }
              }
          }
      }
      ```

      随机添加几个文档

      ```json
      PUT /lib3/user/1
      {
          "name":		"zhangsan",
          "age":		29,
          "address":	"bei jing chao yang qu",
          "birthday":	"1988-12-11",
          "interests":"xi huan music ,hike"
      }
      PUT /lib3/user/2
      {
          "name":		"lisi",
          "age":		28,
          "address":	"si chuan cheng du qing yang qu",
          "birthday":	"1998-09-13",
          "interests":"xi huan music ,hike"
      }
      PUT /lib3/user/3
      {
          "name":		"wangwu",
          "age":		21,
          "address":	"shan xi xi an yan ta qu",
          "birthday":	"1994-12-01",
          "interests":"xi huan music ,hike"
      }
      ```

      基本查询

      `GET /lib3/user/_search?q=name:lisi`

      输出：

      ```json
      {
        "took": 73,   //查询用时，毫秒
        "timed_out": false,
        "_shards": {
          "total": 3,
          "successful": 3,
          "skipped": 0,
          "failed": 0
        },
        "hits": {
          "total": 1,  //匹配的文档个数
          "max_score": 0.2876821,   //相关度分数 值最大为1
          "hits": [
            {
              "_index": "lib3",
              "_type": "user",
              "_id": "2",
              "_score": 0.2876821,
              "_source": {
                "name": "lisi",
                "age": 28,
                "address": "si chuan cheng du qing yang qu",
                "birthday": "1998-09-13",
                "interests": "xi huan music ,hike"
              }
            }
          ]
        }
      }
      ```

      基本查询2：

      `GET /lib3/user/_search?q=interests:changge&sort=age:desc`：查询需要的字段信息并以年龄排序

   2. term查询和terms查询

      `term query`回去倒排索引中寻找确切的term，它并不知道分词器的存在，这种查询适合`keyword,numeric,date`.

      term：查询某个字段里含有某个关键词的文档

      terms：查询某个字段里含有多个关键词的文档

      ```json
      GET /lib3/user/_search/{"query":{"term":{"interests":"changge"}}}
      GET /lib3/user/_search/{"query":{"term":{"interests":["changge","hejiu"]}}}
      ```

   3. 控制查询返回的数量

      from:从哪一个文档开始查询，size：需要的个数

      ```json
      GET /lib3/user/_search/{"from":0,"size":2,"query":{"term":{"interests":["changge","hejiu"]}}}
      ```

   4. 返回版本号

      ```json
      GET /lib3/user/_search/{"version":true,"query":{"term"}:{"interests":"changge"}}
      ```

   5. match查询

      `match query`知道分词器的存在，会对field进行分词操作，然乎在查询

      ```json
      GET /lib3/user/_search {"query":{"match":{"name":"zhaoliu"}}}
      GET /lib3/user/_search {"query":{"match":{"age":20}}}
      ```

      `match_all`查看所有文档

      ```json
      GET /lib3/user/_search {"query":{"match_all":{}}}
      ```

      `multi_match`：可以指定多个字段

      ```json
      GET /lib3/user/_search {"query":{"multi_match":{"query":"lvyou","field":["interests","name"]}}}
      ```

      `match_phrase`：短语匹配查询：

      - ES引擎首先分析查询字符串，从分析后的文本中构建短语查询，这意味着必须匹配短语中的所有分词，并且保证各个分词的相对位置不变。

      ```json
      GET /lib3/user/_search
      {
      	"query":{
              "match_phrase":{
                  "interests":"duanlian,shuoxiangsheng"
              }
          }
      }
      ```

   6. 排序

      使用sort实现排序：desc降序，asc升序

      ```json
      GET /lib3/user/_search
      {
      	"query":{
              "match_all":{}
          },
          "sort":{
              "age":{
                  "order":"desc"
              }
          }
      }
      ```

   7. 前缀匹配查询

      ```json
      GET /lib3/user/_search {"query":{"match_parse_prefix":{"name"{"query":"zhao"}}}}
      ```

   8. 范围查询

      ```json
      GET /lib3/user/_search
      {
          "query":{
              "range":{
                  "birthday":{
                      "from":"1980-10-10",
                      "to":"2019-10-10",
                      "include_lower":true,
                      "include_upper":false
                  }
              }
          }
      }
      ```

   9. wildcard查询

      允许使用通配符来进行查询

      * *代表0或多个字符
      * ？代表任意一个字符

      ```json
      GET /lib3/user/_search {"query":{"wildcard":"name":"zhao*"}}
      ```

   10. fuzzy实现模糊查询

       - value：查询的关键字
       - boost：查询的权值，默认值是1.0
       - min_similarity：设置匹配的最小相似度，默认为0.5

   11. 高亮搜索结果

9. 