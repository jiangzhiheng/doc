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

   

4. 