package org.springframework.samples.petclinic.util.log;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.services.logs.AWSLogs;
import com.amazonaws.services.logs.AWSLogsClientBuilder;
import com.amazonaws.services.logs.model.CreateLogStreamRequest;
import com.amazonaws.services.logs.model.DescribeLogStreamsRequest;
import com.amazonaws.services.logs.model.DescribeLogStreamsResult;
import com.amazonaws.services.logs.model.InputLogEvent;
import com.amazonaws.services.logs.model.LogStream;
import com.amazonaws.services.logs.model.PutLogEventsRequest;
import com.amazonaws.services.logs.model.ResourceAlreadyExistsException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public abstract class AwsCloudWatchLogUtil {
	private static Lock lock = new ReentrantLock();
	private static AWSLogs cloudWatchlog;
	private static String LOG_GROUP = "mbp3ApplicationLog";
    private static String LOG_STREAM = "mbp3ApplicationLog_Stream_";
    private static ObjectMapper om = new ObjectMapper();
    
    public static void putLog(Map<String, String> logMap) throws JsonProcessingException {
    		// 이 부분을 매번 실행하지 않고 한번만 실행하고 사용하면 안된다. 그러면 일정 시간이 지난 후에 아래와 같은 오류가 발생한다.
    	    // 이유는 InstanceProfile은 일정시간 동안만 유효하기 때문이다. 아래처럼 매번 생성하면 내부에서 자동 refresh된다.
    		// The security token included in the request is expired (Service: AWSLogs; Status Code: 400; Error Code: ExpiredTokenException; Request ID: 2d9540f1-9367-11e7-b371-fd5cec78346e)
		AWSCredentialsProvider provider = DefaultAWSCredentialsProviderChain.getInstance();
		AWSCredentials credential = provider.getCredentials();
		AWSLogsClientBuilder builder = AWSLogsClientBuilder.standard();
		builder.setRegion("ap-northeast-2");
		cloudWatchlog = builder.withCredentials(new AWSStaticCredentialsProvider(credential)).build();
	
		// building a put request log
        PutLogEventsRequest request = new PutLogEventsRequest();
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat sf = new SimpleDateFormat("MM/dd/yyyy");
        // TODO : log group and log stream should be checked to be existed before set.
        String logStreamName = LOG_STREAM + sf.format(calendar.getTime());
        try {
        		CreateLogStreamRequest createLogStreamRequest = new CreateLogStreamRequest(LOG_GROUP, logStreamName);
        		cloudWatchlog.createLogStream(createLogStreamRequest);
        } catch(ResourceAlreadyExistsException ignore) { }
        request.setLogGroupName(LOG_GROUP);
        request.setLogStreamName(logStreamName);
        // building my log event
        InputLogEvent log = new InputLogEvent();
        log.setMessage(om.writeValueAsString(logMap));
        log.setTimestamp(calendar.getTimeInMillis());
        // building the array list log event
        ArrayList<InputLogEvent> logEvents = new ArrayList<InputLogEvent>();
        logEvents.add(log);
        // setting the error array list
        request.setLogEvents(logEvents);
        // make the request
        // Resolved exception caused by Handler execution: com.amazonaws.services.logs.model.InvalidSequenceTokenException: The given sequenceToken is invalid. The next expected sequenceToken is:
        // The above error is caused by non-sequence token. Request must have a sequence token.
        // TODO : I think this need to be syncronized for multithread.
        try {
        		lock.lock();
            DescribeLogStreamsRequest describeLogStreamsRequest = new DescribeLogStreamsRequest(LOG_GROUP);
            DescribeLogStreamsResult describeLogStreamsResult = cloudWatchlog.describeLogStreams(describeLogStreamsRequest);
            List<LogStream> logStreams = describeLogStreamsResult.getLogStreams();
            String sequenceToken = null;
            for(LogStream logStream : logStreams) {
            		if(logStreamName.equals(logStream.getLogStreamName())) {
            			sequenceToken = logStream.getUploadSequenceToken();
            			break;
            		}
            }
            request.setSequenceToken(sequenceToken);
            cloudWatchlog.putLogEvents(request);
        } finally {
        		lock.unlock();
        }

    }
}
