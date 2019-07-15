# 安装
## 一. 源码安装
### 1. 下载源码
```sh
wget http://download.redis.io/releases/redis-3.2.1.tar.gz

```

### 2. 编译
```sh

cd redis-3.2.1/src
make

```
### 3. 启动
```sh
cd src/
./redis-server ../redis.conf # 表示已redis.conf配置开启redis服务

```
- src中redis-server为服务端
- src中redis-cli为客户端

#### 配置文件
```conf

#数据目录，数据库的写入会在这个目录。rdb、aof文件也会写在这个目录
dir /var/lib/redis

#是否在后台执行，yes：后台运行；no：不是后台运行（老版本默认）
daemonize yes

#redis的进程文件
pidfile /var/run/redis/redis-server.pid

#redis监听的端口号。
port 6379

#指定 redis 只接收来自于该 IP 地址的请求，如果不进行设置，那么将处理所有请求
bind 127.0.0.1

#指定了记录日志的文件。空字符串的话，日志会打印到标准输出设备。后台运行的redis标准输出是/dev/null。
logfile /var/log/redis/redis-server.log

#指定了服务端日志的级别。级别包括：debug（很多信息，方便开发、测试），verbose（许多有用的信息，但是没有debug级别信息多），notice（适当的日志级别，适合生产环境），warn（只有非常重要的信息）
loglevel notice

#默认redis使用的是rdb方式持久化，这种方式在许多应用中已经足够用了。但是redis如果中途宕机，会导致可能有几分钟的数据丢失，根据save来策略进行持久化，Append Only File是另一种持久化方式，可以提供更好的持久化特性。Redis会把每次写入的数据在接收后都写入 appendonly.aof 文件，每次启动时Redis都会先把这个文件的数据读入内存里，先忽略RDB文件。
appendonly no

```
#### 服务配置
由于是通过源码编译安装所以不会被配置到service 和 chkconfig中,需要自己编写服务脚本

##### 脚本
在redis/util/中redis_init_script文件复制到/etc/int.d/内重命名如redisd
```
#!/bin/sh
# chkconfig:   2345 90 10
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.

# 端口 
REDISPORT=6379

# 服务端
EXEC=/usr/local/bin/redis-server

# 客户端
CLIEXEC=/usr/local/bin/redis-cli

# 进程文件 在配置文件中有配置
PIDFILE=/var/run/redis_${REDISPORT}.pid

# 配置文件
CONF="/usr/local/redis-3.2.1/redis.conf"

case "$1" in
    start)
        if [ -f $PIDFILE ]
        then
                echo "$PIDFILE exists, process is already running or crashed"
        else
                echo "Starting Redis server..."
                $EXEC $CONF
        fi
        ;;
    stop)
        if [ ! -f $PIDFILE ]
        then
                echo "$PIDFILE does not exist, process is not running"
        else
                PID=$(cat $PIDFILE)
                echo "Stopping ..."
                $CLIEXEC -p $REDISPORT shutdown
                while [ -x /proc/${PID} ]
                do
                    echo "Waiting for Redis to shutdown ..."
                    sleep 1
                done
                echo "Redis stopped"
        fi
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac

```
- # chkconfig:   2345 90 10 修改运行级别

配置完成后
```s
#设置为开机自启动服务器
chkconfig redisd on

#打开服务
service redisd start

#关闭服务
service redisd stop
```
# Docker安装
```s
docker run -v /myredis/conf/redis.conf:/usr/local/etc/redis/redis.conf --name myredis -d -p 6379:6379 redis redis-server /usr/local/etc/redis/redis.conf

```

# Redis的使用

## Spring下的使用
### RedisTemplate
RedisTemplate主要步骤
- 创建jedis连接池

- 连接池中获取jedis连接

- 使用jedis来进行实际操作
源码:
```java

package org.springframework.data.redis.core;

import java.io.Closeable;
import java.lang.reflect.Proxy;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import org.springframework.beans.factory.BeanClassLoaderAware;
import org.springframework.dao.InvalidDataAccessApiUsageException;
import org.springframework.data.redis.connection.DataType;
import org.springframework.data.redis.connection.RedisConnection;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.RedisKeyCommands;
import org.springframework.data.redis.connection.RedisServerCommands;
import org.springframework.data.redis.connection.RedisTxCommands;
import org.springframework.data.redis.connection.SortParameters;
import org.springframework.data.redis.connection.RedisZSetCommands.Tuple;
import org.springframework.data.redis.core.ZSetOperations.TypedTuple;
import org.springframework.data.redis.core.query.QueryUtils;
import org.springframework.data.redis.core.query.SortQuery;
import org.springframework.data.redis.core.script.DefaultScriptExecutor;
import org.springframework.data.redis.core.script.RedisScript;
import org.springframework.data.redis.core.script.ScriptExecutor;
import org.springframework.data.redis.core.types.RedisClientInfo;
import org.springframework.data.redis.serializer.JdkSerializationRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializer;
import org.springframework.data.redis.serializer.SerializationUtils;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.lang.Nullable;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.util.Assert;
import org.springframework.util.ClassUtils;
import org.springframework.util.CollectionUtils;

public class RedisTemplate<K, V> extends RedisAccessor implements RedisOperations<K, V>, BeanClassLoaderAware {

    private boolean enableTransactionSupport = false;
    private boolean exposeConnection = false;
    private boolean initialized = false;
    private boolean enableDefaultSerializer = true;
    @Nullable
    private RedisSerializer<?> defaultSerializer;
    @Nullable
    private ClassLoader classLoader;
    @Nullable
    private RedisSerializer keySerializer = null;
    @Nullable
    private RedisSerializer valueSerializer = null;
    @Nullable
    private RedisSerializer hashKeySerializer = null;
    @Nullable
    private RedisSerializer hashValueSerializer = null;
    private RedisSerializer<String> stringSerializer = new StringRedisSerializer();
    @Nullable
    private ScriptExecutor<K> scriptExecutor;
    @Nullable
    private ValueOperations<K, V> valueOps;
    @Nullable
    private ListOperations<K, V> listOps;
    @Nullable
    private SetOperations<K, V> setOps;
    @Nullable
    private ZSetOperations<K, V> zSetOps;
    @Nullable
    private GeoOperations<K, V> geoOps;
    @Nullable
    private HyperLogLogOperations<K, V> hllOps;

    public RedisTemplate() {
    }

    public void afterPropertiesSet() {
        super.afterPropertiesSet();
        boolean defaultUsed = false;
        if (this.defaultSerializer == null) {
            this.defaultSerializer = new JdkSerializationRedisSerializer(this.classLoader != null ? this.classLoader : this.getClass().getClassLoader());
        }

        if (this.enableDefaultSerializer) {
            if (this.keySerializer == null) {
                this.keySerializer = this.defaultSerializer;
                defaultUsed = true;
            }

            if (this.valueSerializer == null) {
                this.valueSerializer = this.defaultSerializer;
                defaultUsed = true;
            }

            if (this.hashKeySerializer == null) {
                this.hashKeySerializer = this.defaultSerializer;
                defaultUsed = true;
            }

            if (this.hashValueSerializer == null) {
                this.hashValueSerializer = this.defaultSerializer;
                defaultUsed = true;
            }
        }

        if (this.enableDefaultSerializer && defaultUsed) {
            Assert.notNull(this.defaultSerializer, "default serializer null and not all serializers initialized");
        }

        if (this.scriptExecutor == null) {
            this.scriptExecutor = new DefaultScriptExecutor(this);
        }

        this.initialized = true;
    }

    @Nullable
    public <T> T execute(RedisCallback<T> action) {
        return this.execute(action, this.isExposeConnection());
    }

    @Nullable
    public <T> T execute(RedisCallback<T> action, boolean exposeConnection) {
        return this.execute(action, exposeConnection, false);
    }

    @Nullable
    public <T> T execute(RedisCallback<T> action, boolean exposeConnection, boolean pipeline) {
        Assert.isTrue(this.initialized, "template not initialized; call afterPropertiesSet() before using it");
        Assert.notNull(action, "Callback object must not be null");
        RedisConnectionFactory factory = this.getRequiredConnectionFactory();
        RedisConnection conn = null;

        Object var11;
        try {
            if (this.enableTransactionSupport) {
                conn = RedisConnectionUtils.bindConnection(factory, this.enableTransactionSupport);
            } else {
                conn = RedisConnectionUtils.getConnection(factory);
            }

            boolean existingConnection = TransactionSynchronizationManager.hasResource(factory);
            RedisConnection connToUse = this.preProcessConnection(conn, existingConnection);
            boolean pipelineStatus = connToUse.isPipelined();
            if (pipeline && !pipelineStatus) {
                connToUse.openPipeline();
            }

            RedisConnection connToExpose = exposeConnection ? connToUse : this.createRedisConnectionProxy(connToUse);
            T result = action.doInRedis(connToExpose);
            if (pipeline && !pipelineStatus) {
                connToUse.closePipeline();
            }

            var11 = this.postProcessResult(result, connToUse, existingConnection);
        } finally {
            RedisConnectionUtils.releaseConnection(conn, factory);
        }

        return var11;
    }

    public <T> T execute(SessionCallback<T> session) {
        Assert.isTrue(this.initialized, "template not initialized; call afterPropertiesSet() before using it");
        Assert.notNull(session, "Callback object must not be null");
        RedisConnectionFactory factory = this.getRequiredConnectionFactory();
        RedisConnectionUtils.bindConnection(factory, this.enableTransactionSupport);

        Object var3;
        try {
            var3 = session.execute(this);
        } finally {
            RedisConnectionUtils.unbindConnection(factory);
        }

        return var3;
    }

    public List<Object> executePipelined(SessionCallback<?> session) {
        return this.executePipelined(session, this.valueSerializer);
    }

    public List<Object> executePipelined(SessionCallback<?> session, @Nullable RedisSerializer<?> resultSerializer) {
        Assert.isTrue(this.initialized, "template not initialized; call afterPropertiesSet() before using it");
        Assert.notNull(session, "Callback object must not be null");
        RedisConnectionFactory factory = this.getRequiredConnectionFactory();
        RedisConnectionUtils.bindConnection(factory, this.enableTransactionSupport);

        List var4;
        try {
            var4 = (List)this.execute((connection) -> {
                connection.openPipeline();
                boolean pipelinedClosed = false;

                List var7;
                try {
                    Object result = this.executeSession(session);
                    if (result != null) {
                        throw new InvalidDataAccessApiUsageException("Callback cannot return a non-null value as it gets overwritten by the pipeline");
                    }

                    List<Object> closePipeline = connection.closePipeline();
                    pipelinedClosed = true;
                    var7 = this.deserializeMixedResults(closePipeline, resultSerializer, this.hashKeySerializer, this.hashValueSerializer);
                } finally {
                    if (!pipelinedClosed) {
                        connection.closePipeline();
                    }

                }

                return var7;
            });
        } finally {
            RedisConnectionUtils.unbindConnection(factory);
        }

        return var4;
    }

    public List<Object> executePipelined(RedisCallback<?> action) {
        return this.executePipelined(action, this.valueSerializer);
    }

    public List<Object> executePipelined(RedisCallback<?> action, @Nullable RedisSerializer<?> resultSerializer) {
        return (List)this.execute((connection) -> {
            connection.openPipeline();
            boolean pipelinedClosed = false;

            List var7;
            try {
                Object result = action.doInRedis(connection);
                if (result != null) {
                    throw new InvalidDataAccessApiUsageException("Callback cannot return a non-null value as it gets overwritten by the pipeline");
                }

                List<Object> closePipeline = connection.closePipeline();
                pipelinedClosed = true;
                var7 = this.deserializeMixedResults(closePipeline, resultSerializer, this.hashKeySerializer, this.hashValueSerializer);
            } finally {
                if (!pipelinedClosed) {
                    connection.closePipeline();
                }

            }

            return var7;
        });
    }

    public <T> T execute(RedisScript<T> script, List<K> keys, Object... args) {
        return this.scriptExecutor.execute(script, keys, args);
    }

    public <T> T execute(RedisScript<T> script, RedisSerializer<?> argsSerializer, RedisSerializer<T> resultSerializer, List<K> keys, Object... args) {
        return this.scriptExecutor.execute(script, argsSerializer, resultSerializer, keys, args);
    }

    public <T extends Closeable> T executeWithStickyConnection(RedisCallback<T> callback) {
        Assert.isTrue(this.initialized, "template not initialized; call afterPropertiesSet() before using it");
        Assert.notNull(callback, "Callback object must not be null");
        RedisConnectionFactory factory = this.getRequiredConnectionFactory();
        RedisConnection connection = this.preProcessConnection(RedisConnectionUtils.doGetConnection(factory, true, false, false), false);
        return (Closeable)callback.doInRedis(connection);
    }

    private Object executeSession(SessionCallback<?> session) {
        return session.execute(this);
    }

    protected RedisConnection createRedisConnectionProxy(RedisConnection pm) {
        Class<?>[] ifcs = ClassUtils.getAllInterfacesForClass(pm.getClass(), this.getClass().getClassLoader());
        return (RedisConnection)Proxy.newProxyInstance(pm.getClass().getClassLoader(), ifcs, new CloseSuppressingInvocationHandler(pm));
    }

    protected RedisConnection preProcessConnection(RedisConnection connection, boolean existingConnection) {
        return connection;
    }

    @Nullable
    protected <T> T postProcessResult(@Nullable T result, RedisConnection conn, boolean existingConnection) {
        return result;
    }

    public boolean isExposeConnection() {
        return this.exposeConnection;
    }

    public void setExposeConnection(boolean exposeConnection) {
        this.exposeConnection = exposeConnection;
    }

    public boolean isEnableDefaultSerializer() {
        return this.enableDefaultSerializer;
    }

    public void setEnableDefaultSerializer(boolean enableDefaultSerializer) {
        this.enableDefaultSerializer = enableDefaultSerializer;
    }

    @Nullable
    public RedisSerializer<?> getDefaultSerializer() {
        return this.defaultSerializer;
    }

    public void setDefaultSerializer(RedisSerializer<?> serializer) {
        this.defaultSerializer = serializer;
    }

    public void setKeySerializer(RedisSerializer<?> serializer) {
        this.keySerializer = serializer;
    }

    public RedisSerializer<?> getKeySerializer() {
        return this.keySerializer;
    }

    public void setValueSerializer(RedisSerializer<?> serializer) {
        this.valueSerializer = serializer;
    }

    public RedisSerializer<?> getValueSerializer() {
        return this.valueSerializer;
    }

    public RedisSerializer<?> getHashKeySerializer() {
        return this.hashKeySerializer;
    }

    public void setHashKeySerializer(RedisSerializer<?> hashKeySerializer) {
        this.hashKeySerializer = hashKeySerializer;
    }

    public RedisSerializer<?> getHashValueSerializer() {
        return this.hashValueSerializer;
    }

    public void setHashValueSerializer(RedisSerializer<?> hashValueSerializer) {
        this.hashValueSerializer = hashValueSerializer;
    }

    public RedisSerializer<String> getStringSerializer() {
        return this.stringSerializer;
    }

    public void setStringSerializer(RedisSerializer<String> stringSerializer) {
        this.stringSerializer = stringSerializer;
    }

    public void setScriptExecutor(ScriptExecutor<K> scriptExecutor) {
        this.scriptExecutor = scriptExecutor;
    }

    private byte[] rawKey(Object key) {
        Assert.notNull(key, "non null key required");
        return this.keySerializer == null && key instanceof byte[] ? (byte[])((byte[])key) : this.keySerializer.serialize(key);
    }

    private byte[] rawString(String key) {
        return this.stringSerializer.serialize(key);
    }

    private byte[] rawValue(Object value) {
        return this.valueSerializer == null && value instanceof byte[] ? (byte[])((byte[])value) : this.valueSerializer.serialize(value);
    }

    private byte[][] rawKeys(Collection<K> keys) {
        byte[][] rawKeys = new byte[keys.size()][];
        int i = 0;

        Object key;
        for(Iterator var4 = keys.iterator(); var4.hasNext(); rawKeys[i++] = this.rawKey(key)) {
            key = var4.next();
        }

        return rawKeys;
    }

    private K deserializeKey(byte[] value) {
        return this.keySerializer != null ? this.keySerializer.deserialize(value) : value;
    }

    @Nullable
    private List<Object> deserializeMixedResults(@Nullable List<Object> rawValues, @Nullable RedisSerializer valueSerializer, @Nullable RedisSerializer hashKeySerializer, @Nullable RedisSerializer hashValueSerializer) {
        if (rawValues == null) {
            return null;
        } else {
            List<Object> values = new ArrayList();
            Iterator var6 = rawValues.iterator();

            while(true) {
                while(var6.hasNext()) {
                    Object rawValue = var6.next();
                    if (rawValue instanceof byte[] && valueSerializer != null) {
                        values.add(valueSerializer.deserialize((byte[])((byte[])rawValue)));
                    } else if (rawValue instanceof List) {
                        values.add(this.deserializeMixedResults((List)rawValue, valueSerializer, hashKeySerializer, hashValueSerializer));
                    } else if (rawValue instanceof Set && !((Set)rawValue).isEmpty()) {
                        values.add(this.deserializeSet((Set)rawValue, valueSerializer));
                    } else if (rawValue instanceof Map && !((Map)rawValue).isEmpty() && ((Map)rawValue).values().iterator().next() instanceof byte[]) {
                        values.add(SerializationUtils.deserialize((Map)rawValue, hashKeySerializer, hashValueSerializer));
                    } else {
                        values.add(rawValue);
                    }
                }

                return values;
            }
        }
    }

    private Set<?> deserializeSet(Set rawSet, @Nullable RedisSerializer valueSerializer) {
        if (rawSet.isEmpty()) {
            return rawSet;
        } else {
            Object setValue = rawSet.iterator().next();
            if (setValue instanceof byte[] && valueSerializer != null) {
                return SerializationUtils.deserialize(rawSet, valueSerializer);
            } else {
                return setValue instanceof Tuple ? this.convertTupleValues(rawSet, valueSerializer) : rawSet;
            }
        }
    }

    private Set<TypedTuple<V>> convertTupleValues(Set<Tuple> rawValues, @Nullable RedisSerializer valueSerializer) {
        Set<TypedTuple<V>> set = new LinkedHashSet(rawValues.size());

        Tuple rawValue;
        Object value;
        for(Iterator var4 = rawValues.iterator(); var4.hasNext(); set.add(new DefaultTypedTuple(value, rawValue.getScore()))) {
            rawValue = (Tuple)var4.next();
            value = rawValue.getValue();
            if (valueSerializer != null) {
                value = valueSerializer.deserialize(rawValue.getValue());
            }
        }

        return set;
    }

    public List<Object> exec() {
        List<Object> results = this.execRaw();
        return this.getRequiredConnectionFactory().getConvertPipelineAndTxResults() ? this.deserializeMixedResults(results, this.valueSerializer, this.hashKeySerializer, this.hashValueSerializer) : results;
    }

    public List<Object> exec(RedisSerializer<?> valueSerializer) {
        return this.deserializeMixedResults(this.execRaw(), valueSerializer, valueSerializer, valueSerializer);
    }

    protected List<Object> execRaw() {
        List<Object> raw = (List)this.execute(RedisTxCommands::exec);
        return raw == null ? Collections.emptyList() : raw;
    }

    public Boolean delete(K key) {
        byte[] rawKey = this.rawKey(key);
        Long result = (Long)this.execute((connection) -> {
            return connection.del(new byte[][]{rawKey});
        }, true);
        return result != null && result.intValue() == 1;
    }

    public Long delete(Collection<K> keys) {
        if (CollectionUtils.isEmpty(keys)) {
            return 0L;
        } else {
            byte[][] rawKeys = this.rawKeys(keys);
            return (Long)this.execute((connection) -> {
                return connection.del(rawKeys);
            }, true);
        }
    }

    public Boolean hasKey(K key) {
        byte[] rawKey = this.rawKey(key);
        return (Boolean)this.execute((connection) -> {
            return connection.exists(rawKey);
        }, true);
    }

    public Boolean expire(K key, long timeout, TimeUnit unit) {
        byte[] rawKey = this.rawKey(key);
        long rawTimeout = TimeoutUtils.toMillis(timeout, unit);
        return (Boolean)this.execute((connection) -> {
            try {
                return connection.pExpire(rawKey, rawTimeout);
            } catch (Exception var8) {
                return connection.expire(rawKey, TimeoutUtils.toSeconds(timeout, unit));
            }
        }, true);
    }

    public Boolean expireAt(K key, Date date) {
        byte[] rawKey = this.rawKey(key);
        return (Boolean)this.execute((connection) -> {
            try {
                return connection.pExpireAt(rawKey, date.getTime());
            } catch (Exception var4) {
                return connection.expireAt(rawKey, date.getTime() / 1000L);
            }
        }, true);
    }

    public void convertAndSend(String channel, Object message) {
        Assert.hasText(channel, "a non-empty channel is required");
        byte[] rawChannel = this.rawString(channel);
        byte[] rawMessage = this.rawValue(message);
        this.execute((connection) -> {
            connection.publish(rawChannel, rawMessage);
            return null;
        }, true);
    }

    public Long getExpire(K key) {
        byte[] rawKey = this.rawKey(key);
        return (Long)this.execute((connection) -> {
            return connection.ttl(rawKey);
        }, true);
    }

    public Long getExpire(K key, TimeUnit timeUnit) {
        byte[] rawKey = this.rawKey(key);
        return (Long)this.execute((connection) -> {
            try {
                return connection.pTtl(rawKey, timeUnit);
            } catch (Exception var4) {
                return connection.ttl(rawKey, timeUnit);
            }
        }, true);
    }

    public Set<K> keys(K pattern) {
        byte[] rawKey = this.rawKey(pattern);
        Set<byte[]> rawKeys = (Set)this.execute((connection) -> {
            return connection.keys(rawKey);
        }, true);
        return this.keySerializer != null ? SerializationUtils.deserialize(rawKeys, this.keySerializer) : rawKeys;
    }

    public Boolean persist(K key) {
        byte[] rawKey = this.rawKey(key);
        return (Boolean)this.execute((connection) -> {
            return connection.persist(rawKey);
        }, true);
    }

    public Boolean move(K key, int dbIndex) {
        byte[] rawKey = this.rawKey(key);
        return (Boolean)this.execute((connection) -> {
            return connection.move(rawKey, dbIndex);
        }, true);
    }

    public K randomKey() {
        byte[] rawKey = (byte[])this.execute(RedisKeyCommands::randomKey, true);
        return this.deserializeKey(rawKey);
    }

    public void rename(K oldKey, K newKey) {
        byte[] rawOldKey = this.rawKey(oldKey);
        byte[] rawNewKey = this.rawKey(newKey);
        this.execute((connection) -> {
            connection.rename(rawOldKey, rawNewKey);
            return null;
        }, true);
    }

    public Boolean renameIfAbsent(K oldKey, K newKey) {
        byte[] rawOldKey = this.rawKey(oldKey);
        byte[] rawNewKey = this.rawKey(newKey);
        return (Boolean)this.execute((connection) -> {
            return connection.renameNX(rawOldKey, rawNewKey);
        }, true);
    }

    public DataType type(K key) {
        byte[] rawKey = this.rawKey(key);
        return (DataType)this.execute((connection) -> {
            return connection.type(rawKey);
        }, true);
    }

    public byte[] dump(K key) {
        byte[] rawKey = this.rawKey(key);
        return (byte[])this.execute((connection) -> {
            return connection.dump(rawKey);
        }, true);
    }

    public void restore(K key, byte[] value, long timeToLive, TimeUnit unit) {
        byte[] rawKey = this.rawKey(key);
        long rawTimeout = TimeoutUtils.toMillis(timeToLive, unit);
        this.execute((connection) -> {
            connection.restore(rawKey, rawTimeout, value);
            return null;
        }, true);
    }

    public void multi() {
        this.execute((connection) -> {
            connection.multi();
            return null;
        }, true);
    }

    public void discard() {
        this.execute((connection) -> {
            connection.discard();
            return null;
        }, true);
    }

    public void watch(K key) {
        byte[] rawKey = this.rawKey(key);
        this.execute((connection) -> {
            connection.watch(new byte[][]{rawKey});
            return null;
        }, true);
    }

    public void watch(Collection<K> keys) {
        byte[][] rawKeys = this.rawKeys(keys);
        this.execute((connection) -> {
            connection.watch(rawKeys);
            return null;
        }, true);
    }

    public void unwatch() {
        this.execute((connection) -> {
            connection.unwatch();
            return null;
        }, true);
    }

    public List<V> sort(SortQuery<K> query) {
        return this.sort(query, this.valueSerializer);
    }

    public <T> List<T> sort(SortQuery<K> query, @Nullable RedisSerializer<T> resultSerializer) {
        byte[] rawKey = this.rawKey(query.getKey());
        SortParameters params = QueryUtils.convertQuery(query, this.stringSerializer);
        List<byte[]> vals = (List)this.execute((connection) -> {
            return connection.sort(rawKey, params);
        }, true);
        return SerializationUtils.deserialize(vals, resultSerializer);
    }

    public <T> List<T> sort(SortQuery<K> query, BulkMapper<T, V> bulkMapper) {
        return this.sort(query, bulkMapper, this.valueSerializer);
    }

    public <T, S> List<T> sort(SortQuery<K> query, BulkMapper<T, S> bulkMapper, @Nullable RedisSerializer<S> resultSerializer) {
        List<S> values = this.sort(query, resultSerializer);
        if (values != null && !values.isEmpty()) {
            int bulkSize = query.getGetPattern().size();
            List<T> result = new ArrayList(values.size() / bulkSize + 1);
            List<S> bulk = new ArrayList(bulkSize);
            Iterator var8 = values.iterator();

            while(var8.hasNext()) {
                S s = var8.next();
                bulk.add(s);
                if (bulk.size() == bulkSize) {
                    result.add(bulkMapper.mapBulk(Collections.unmodifiableList(bulk)));
                    bulk = new ArrayList(bulkSize);
                }
            }

            return result;
        } else {
            return Collections.emptyList();
        }
    }

    public Long sort(SortQuery<K> query, K storeKey) {
        byte[] rawStoreKey = this.rawKey(storeKey);
        byte[] rawKey = this.rawKey(query.getKey());
        SortParameters params = QueryUtils.convertQuery(query, this.stringSerializer);
        return (Long)this.execute((connection) -> {
            return connection.sort(rawKey, params, rawStoreKey);
        }, true);
    }

    public void killClient(String host, int port) {
        this.execute((connection) -> {
            connection.killClient(host, port);
            return null;
        });
    }

    public List<RedisClientInfo> getClientList() {
        return (List)this.execute(RedisServerCommands::getClientList);
    }

    public void slaveOf(String host, int port) {
        this.execute((connection) -> {
            connection.slaveOf(host, port);
            return null;
        });
    }

    public void slaveOfNoOne() {
        this.execute((connection) -> {
            connection.slaveOfNoOne();
            return null;
        });
    }

    public ClusterOperations<K, V> opsForCluster() {
        return new DefaultClusterOperations(this);
    }

    public GeoOperations<K, V> opsForGeo() {
        if (this.geoOps == null) {
            this.geoOps = new DefaultGeoOperations(this);
        }

        return this.geoOps;
    }

    public BoundGeoOperations<K, V> boundGeoOps(K key) {
        return new DefaultBoundGeoOperations(key, this);
    }

    public <HK, HV> BoundHashOperations<K, HK, HV> boundHashOps(K key) {
        return new DefaultBoundHashOperations(key, this);
    }

    public <HK, HV> HashOperations<K, HK, HV> opsForHash() {
        return new DefaultHashOperations(this);
    }

    public HyperLogLogOperations<K, V> opsForHyperLogLog() {
        if (this.hllOps == null) {
            this.hllOps = new DefaultHyperLogLogOperations(this);
        }

        return this.hllOps;
    }

    public ListOperations<K, V> opsForList() {
        if (this.listOps == null) {
            this.listOps = new DefaultListOperations(this);
        }

        return this.listOps;
    }

    public BoundListOperations<K, V> boundListOps(K key) {
        return new DefaultBoundListOperations(key, this);
    }

    public BoundSetOperations<K, V> boundSetOps(K key) {
        return new DefaultBoundSetOperations(key, this);
    }

    public SetOperations<K, V> opsForSet() {
        if (this.setOps == null) {
            this.setOps = new DefaultSetOperations(this);
        }

        return this.setOps;
    }

    public BoundValueOperations<K, V> boundValueOps(K key) {
        return new DefaultBoundValueOperations(key, this);
    }

    public ValueOperations<K, V> opsForValue() {
        if (this.valueOps == null) {
            this.valueOps = new DefaultValueOperations(this);
        }

        return this.valueOps;
    }

    public BoundZSetOperations<K, V> boundZSetOps(K key) {
        return new DefaultBoundZSetOperations(key, this);
    }

    public ZSetOperations<K, V> opsForZSet() {
        if (this.zSetOps == null) {
            this.zSetOps = new DefaultZSetOperations(this);
        }

        return this.zSetOps;
    }

    public void setEnableTransactionSupport(boolean enableTransactionSupport) {
        this.enableTransactionSupport = enableTransactionSupport;
    }

    public void setBeanClassLoader(ClassLoader classLoader) {
        this.classLoader = classLoader;
    }
}

```

## 数据库异步缓存

# Spring Boot Redis增删改查
Lettuce和Jedis的都是连接Redis Server的客户端程序。2.X版本默认Lettuce
<br>Jedis在实现上是直连redis server，多线程环境下非线程安全，除非使用连接池，为每个Jedis实例增加物理连接。
<br>Lettuce基于Netty的连接实例（StatefulRedisConnection），可以在多个线程间并发访问，且线程安全，满足多线程环境下的并发访问，同时它是可伸缩的设计，一个连接实例不够的情况也可以按需增加连接实例。

# 消息队列
Redis使用双向链表实现列表,可以直接使用Redis的List实现消息队列，只需简单的两个指令
- lpush(尾部插入)和rpop(头部取出)
- rpush(头部插入)和lpop(尾部取出)
- brpop(阻塞式头部取出)和blpop(阻塞式尾部取出)，相对于非阻塞，这个命令会阻塞连接直到列表内有信息可以取

## 生产者消费者模式
生产者将消息放入队列中，指定消费者取获取。一个消息只会被一个消费者获取。
<br>该方法是借助redis的list结构实现的。Producer调用redis的lpush往特定key里塞入消息，Consumer调用brpop去不断监听该key
- 监听者

自己实现org.springframework.data.redis.connection.MessageListener接口生成监听者
```java
package com.definesys.dboperationserver.redismq;

import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;

public class insertListener implements MessageListener {
    @Override
    public void onMessage(Message message, byte[] bytes) {
        //处理该信息逻辑方法，bytes是topic message是消息
        System.out.println(new String(bytes) + "主题发布：" + new String(message.getBody()));
    }
}

```
- 绑定监听者与topic

```java
package com.definesys.dboperationserver.config;

import com.definesys.dboperationserver.redismq.deleteListener;
import com.definesys.dboperationserver.redismq.insertListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.listener.PatternTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;

@Configuration
public class RedisMqConfig {
    @Autowired
    private JedisConnectionFactory jedisConnectionFactory;

    @Bean
    public RedisMessageListenerContainer redisMessageListenerContainer() {

        RedisMessageListenerContainer container = new RedisMessageListenerContainer();

        container.setConnectionFactory(jedisConnectionFactory);

        /**
         * 添加监听者监听不同的主题的发布
         * */
        container.addMessageListener(new insertListener(), new PatternTopic("insert"));
        container.addMessageListener(new deleteListener(),new PatternTopic("delete"));

        return container;
    }
    @Bean
    public StringRedisTemplate stringRedisTemplate(RedisConnectionFactory redisConnectionFactory) {
        return new StringRedisTemplate(redisConnectionFactory);
    }
}

```
- 消息发布者
```java
package com.definesys.dboperationserver.redismq;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class Publisher {
    @Autowired
    StringRedisTemplate redisTemplate;
    public void publish(String topic, Object message) {
        // 该方法封装的 connection.publish(rawChannel, rawMessage);
        redisTemplate.convertAndSend(topic, message);
    }
}

```
## 发布者订阅者模式

# 常用命令
## key操作
### keys 匹配模式
- KEYS * 匹配数据库中所有 key 。
- KEYS h?llo 匹配 hello ， hallo 和 hxllo 等。
- KEYS h*llo 匹配 hllo 和 heeeeello 等。
- KEYS h[ae]llo 匹配 hello 和 hallo ，但不匹配 hillo 。
- 特殊符号用 \ 隔开

### expire key seconds 
设置过期时间，单位秒 pexpire 毫秒单位
- set或是getset 时间不会被改变
- rename key key1 也不会改变时间，如果rename的key1之前存在且有时间，那么时间也会被key覆盖
- persist key 会移除过期时间

### expireat key date (时间戳)
expireat设置过期时间戳，秒单位。pexpireat，毫秒单位。



# 数据类型
## String:
Strings 数据结构是简单的key-value类型，value其实不仅是String，也可以是数字。
常用命令:set,get,decr,incr,mget,appande追加等

## Hash hash表
定义一个hash是一个string类型的key和value的映射表，类似HashMap。
- hset FieldName key value  向filename这个表内插入key value。
- hgetall FileName 获取这个表所有的key
- hget FileName key 获取表的key对应的value

## Set 集合类型
set集合类型，没有重复值。key -> values。
- sadd SetName value1 value2 .... 往setname中加入值
- smembers SetName 获取SetName中的成员值
- sismember SetName value 判断是否是SetName包含value
- srem SetName value 删除SetName的value元素

## Zset 排序集合
对集合的值有顺序编号
- zadd ZSetName 1 value 加入一个值
- zincrby ZSetName 增量(正负) value 原value的权值加上增量


# 原理及实现