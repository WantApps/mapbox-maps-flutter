// Autogenerated from Pigeon (v3.2.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.mapbox.maps.pigeons;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class FLTZnaidyAnnotationMessager {

  public enum OnlineStatus {
    none(0),
    online(1),
    inApp(2),
    offline(3);

    private int index;
    private OnlineStatus(final int index) {
      this.index = index;
    }
  }

  public enum MarkerType {
    none(0),
    self(1),
    friend(2),
    company(3);

    private int index;
    private MarkerType(final int index) {
      this.index = index;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class ZnaidyAnnotationOptions {
    private @Nullable Map<String, Object> geometry;
    public @Nullable Map<String, Object> getGeometry() { return geometry; }
    public void setGeometry(@Nullable Map<String, Object> setterArg) {
      this.geometry = setterArg;
    }

    private @Nullable MarkerType markerType;
    public @Nullable MarkerType getMarkerType() { return markerType; }
    public void setMarkerType(@Nullable MarkerType setterArg) {
      this.markerType = setterArg;
    }

    private @Nullable OnlineStatus onlineStatus;
    public @Nullable OnlineStatus getOnlineStatus() { return onlineStatus; }
    public void setOnlineStatus(@Nullable OnlineStatus setterArg) {
      this.onlineStatus = setterArg;
    }

    private @Nullable List<String> userAvatars;
    public @Nullable List<String> getUserAvatars() { return userAvatars; }
    public void setUserAvatars(@Nullable List<String> setterArg) {
      this.userAvatars = setterArg;
    }

    private @Nullable Long stickerCount;
    public @Nullable Long getStickerCount() { return stickerCount; }
    public void setStickerCount(@Nullable Long setterArg) {
      this.stickerCount = setterArg;
    }

    private @Nullable Long companySize;
    public @Nullable Long getCompanySize() { return companySize; }
    public void setCompanySize(@Nullable Long setterArg) {
      this.companySize = setterArg;
    }

    private @Nullable Long currentSpeed;
    public @Nullable Long getCurrentSpeed() { return currentSpeed; }
    public void setCurrentSpeed(@Nullable Long setterArg) {
      this.currentSpeed = setterArg;
    }

    private @Nullable Double zoomFactor;
    public @Nullable Double getZoomFactor() { return zoomFactor; }
    public void setZoomFactor(@Nullable Double setterArg) {
      this.zoomFactor = setterArg;
    }

    public static final class Builder {
      private @Nullable Map<String, Object> geometry;
      public @NonNull Builder setGeometry(@Nullable Map<String, Object> setterArg) {
        this.geometry = setterArg;
        return this;
      }
      private @Nullable MarkerType markerType;
      public @NonNull Builder setMarkerType(@Nullable MarkerType setterArg) {
        this.markerType = setterArg;
        return this;
      }
      private @Nullable OnlineStatus onlineStatus;
      public @NonNull Builder setOnlineStatus(@Nullable OnlineStatus setterArg) {
        this.onlineStatus = setterArg;
        return this;
      }
      private @Nullable List<String> userAvatars;
      public @NonNull Builder setUserAvatars(@Nullable List<String> setterArg) {
        this.userAvatars = setterArg;
        return this;
      }
      private @Nullable Long stickerCount;
      public @NonNull Builder setStickerCount(@Nullable Long setterArg) {
        this.stickerCount = setterArg;
        return this;
      }
      private @Nullable Long companySize;
      public @NonNull Builder setCompanySize(@Nullable Long setterArg) {
        this.companySize = setterArg;
        return this;
      }
      private @Nullable Long currentSpeed;
      public @NonNull Builder setCurrentSpeed(@Nullable Long setterArg) {
        this.currentSpeed = setterArg;
        return this;
      }
      private @Nullable Double zoomFactor;
      public @NonNull Builder setZoomFactor(@Nullable Double setterArg) {
        this.zoomFactor = setterArg;
        return this;
      }
      public @NonNull ZnaidyAnnotationOptions build() {
        ZnaidyAnnotationOptions pigeonReturn = new ZnaidyAnnotationOptions();
        pigeonReturn.setGeometry(geometry);
        pigeonReturn.setMarkerType(markerType);
        pigeonReturn.setOnlineStatus(onlineStatus);
        pigeonReturn.setUserAvatars(userAvatars);
        pigeonReturn.setStickerCount(stickerCount);
        pigeonReturn.setCompanySize(companySize);
        pigeonReturn.setCurrentSpeed(currentSpeed);
        pigeonReturn.setZoomFactor(zoomFactor);
        return pigeonReturn;
      }
    }
    @NonNull Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("geometry", geometry);
      toMapResult.put("markerType", markerType == null ? null : markerType.index);
      toMapResult.put("onlineStatus", onlineStatus == null ? null : onlineStatus.index);
      toMapResult.put("userAvatars", userAvatars);
      toMapResult.put("stickerCount", stickerCount);
      toMapResult.put("companySize", companySize);
      toMapResult.put("currentSpeed", currentSpeed);
      toMapResult.put("zoomFactor", zoomFactor);
      return toMapResult;
    }
    static @NonNull ZnaidyAnnotationOptions fromMap(@NonNull Map<String, Object> map) {
      ZnaidyAnnotationOptions pigeonResult = new ZnaidyAnnotationOptions();
      Object geometry = map.get("geometry");
      pigeonResult.setGeometry((Map<String, Object>)geometry);
      Object markerType = map.get("markerType");
      pigeonResult.setMarkerType(markerType == null ? null : MarkerType.values()[(int)markerType]);
      Object onlineStatus = map.get("onlineStatus");
      pigeonResult.setOnlineStatus(onlineStatus == null ? null : OnlineStatus.values()[(int)onlineStatus]);
      Object userAvatars = map.get("userAvatars");
      pigeonResult.setUserAvatars((List<String>)userAvatars);
      Object stickerCount = map.get("stickerCount");
      pigeonResult.setStickerCount((stickerCount == null) ? null : ((stickerCount instanceof Integer) ? (Integer)stickerCount : (Long)stickerCount));
      Object companySize = map.get("companySize");
      pigeonResult.setCompanySize((companySize == null) ? null : ((companySize instanceof Integer) ? (Integer)companySize : (Long)companySize));
      Object currentSpeed = map.get("currentSpeed");
      pigeonResult.setCurrentSpeed((currentSpeed == null) ? null : ((currentSpeed instanceof Integer) ? (Integer)currentSpeed : (Long)currentSpeed));
      Object zoomFactor = map.get("zoomFactor");
      pigeonResult.setZoomFactor((Double)zoomFactor);
      return pigeonResult;
    }
  }

  public interface Result<T> {
    void success(T result);
    void error(Throwable error);
  }
  private static class OnZnaidyAnnotationClickListenerCodec extends StandardMessageCodec {
    public static final OnZnaidyAnnotationClickListenerCodec INSTANCE = new OnZnaidyAnnotationClickListenerCodec();
    private OnZnaidyAnnotationClickListenerCodec() {}
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return ZnaidyAnnotationOptions.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value)     {
      if (value instanceof ZnaidyAnnotationOptions) {
        stream.write(128);
        writeValue(stream, ((ZnaidyAnnotationOptions) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java.*/
  public static class OnZnaidyAnnotationClickListener {
    private final BinaryMessenger binaryMessenger;
    public OnZnaidyAnnotationClickListener(BinaryMessenger argBinaryMessenger){
      this.binaryMessenger = argBinaryMessenger;
    }
    public interface Reply<T> {
      void reply(T reply);
    }
    static MessageCodec<Object> getCodec() {
      return OnZnaidyAnnotationClickListenerCodec.INSTANCE;
    }

    public void onZnaidyAnnotationClick(@NonNull String annotationIdArg, @Nullable ZnaidyAnnotationOptions annotationOptionsArg, Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.OnZnaidyAnnotationClickListener.onZnaidyAnnotationClick", getCodec());
      channel.send(new ArrayList<Object>(Arrays.asList(annotationIdArg, annotationOptionsArg)), channelReply -> {
        callback.reply(null);
      });
    }
  }
  private static class _ZnaidyAnnotationMessagerCodec extends StandardMessageCodec {
    public static final _ZnaidyAnnotationMessagerCodec INSTANCE = new _ZnaidyAnnotationMessagerCodec();
    private _ZnaidyAnnotationMessagerCodec() {}
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return ZnaidyAnnotationOptions.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value)     {
      if (value instanceof ZnaidyAnnotationOptions) {
        stream.write(128);
        writeValue(stream, ((ZnaidyAnnotationOptions) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface _ZnaidyAnnotationMessager {
    void create(@NonNull String managerId, @NonNull ZnaidyAnnotationOptions annotationOptions, Result<String> result);
    void update(@NonNull String managerId, @NonNull String annotationId, @NonNull ZnaidyAnnotationOptions annotationOptions, Result<Void> result);
    void delete(@NonNull String managerId, @NonNull String annotationId, @NonNull Boolean animated, Result<Void> result);
    void select(@NonNull String managerId, @NonNull String annotationId, @NonNull Double bottomPadding, Result<Void> result);
    void resetSelection(@NonNull String managerId, @NonNull String annotationId, Result<Void> result);
    void sendSticker(@NonNull String managerId, @NonNull String annotationId, Result<Void> result);
    void setUpdateRate(@NonNull String managerId, @NonNull Long rate, Result<Void> result);

    /** The codec used by _ZnaidyAnnotationMessager. */
    static MessageCodec<Object> getCodec() {
      return _ZnaidyAnnotationMessagerCodec.INSTANCE;
    }

    /** Sets up an instance of `_ZnaidyAnnotationMessager` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, _ZnaidyAnnotationMessager api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon._ZnaidyAnnotationMessager.create", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String managerIdArg = (String)args.get(0);
              if (managerIdArg == null) {
                throw new NullPointerException("managerIdArg unexpectedly null.");
              }
              ZnaidyAnnotationOptions annotationOptionsArg = (ZnaidyAnnotationOptions)args.get(1);
              if (annotationOptionsArg == null) {
                throw new NullPointerException("annotationOptionsArg unexpectedly null.");
              }
              Result<String> resultCallback = new Result<String>() {
                public void success(String result) {
                  wrapped.put("result", result);
                  reply.reply(wrapped);
                }
                public void error(Throwable error) {
                  wrapped.put("error", wrapError(error));
                  reply.reply(wrapped);
                }
              };

              api.create(managerIdArg, annotationOptionsArg, resultCallback);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon._ZnaidyAnnotationMessager.update", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String managerIdArg = (String)args.get(0);
              if (managerIdArg == null) {
                throw new NullPointerException("managerIdArg unexpectedly null.");
              }
              String annotationIdArg = (String)args.get(1);
              if (annotationIdArg == null) {
                throw new NullPointerException("annotationIdArg unexpectedly null.");
              }
              ZnaidyAnnotationOptions annotationOptionsArg = (ZnaidyAnnotationOptions)args.get(2);
              if (annotationOptionsArg == null) {
                throw new NullPointerException("annotationOptionsArg unexpectedly null.");
              }
              Result<Void> resultCallback = new Result<Void>() {
                public void success(Void result) {
                  wrapped.put("result", null);
                  reply.reply(wrapped);
                }
                public void error(Throwable error) {
                  wrapped.put("error", wrapError(error));
                  reply.reply(wrapped);
                }
              };

              api.update(managerIdArg, annotationIdArg, annotationOptionsArg, resultCallback);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon._ZnaidyAnnotationMessager.delete", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String managerIdArg = (String)args.get(0);
              if (managerIdArg == null) {
                throw new NullPointerException("managerIdArg unexpectedly null.");
              }
              String annotationIdArg = (String)args.get(1);
              if (annotationIdArg == null) {
                throw new NullPointerException("annotationIdArg unexpectedly null.");
              }
              Boolean animatedArg = (Boolean)args.get(2);
              if (animatedArg == null) {
                throw new NullPointerException("animatedArg unexpectedly null.");
              }
              Result<Void> resultCallback = new Result<Void>() {
                public void success(Void result) {
                  wrapped.put("result", null);
                  reply.reply(wrapped);
                }
                public void error(Throwable error) {
                  wrapped.put("error", wrapError(error));
                  reply.reply(wrapped);
                }
              };

              api.delete(managerIdArg, annotationIdArg, animatedArg, resultCallback);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon._ZnaidyAnnotationMessager.select", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String managerIdArg = (String)args.get(0);
              if (managerIdArg == null) {
                throw new NullPointerException("managerIdArg unexpectedly null.");
              }
              String annotationIdArg = (String)args.get(1);
              if (annotationIdArg == null) {
                throw new NullPointerException("annotationIdArg unexpectedly null.");
              }
              Double bottomPaddingArg = (Double)args.get(2);
              if (bottomPaddingArg == null) {
                throw new NullPointerException("bottomPaddingArg unexpectedly null.");
              }
              Result<Void> resultCallback = new Result<Void>() {
                public void success(Void result) {
                  wrapped.put("result", null);
                  reply.reply(wrapped);
                }
                public void error(Throwable error) {
                  wrapped.put("error", wrapError(error));
                  reply.reply(wrapped);
                }
              };

              api.select(managerIdArg, annotationIdArg, bottomPaddingArg, resultCallback);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon._ZnaidyAnnotationMessager.resetSelection", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String managerIdArg = (String)args.get(0);
              if (managerIdArg == null) {
                throw new NullPointerException("managerIdArg unexpectedly null.");
              }
              String annotationIdArg = (String)args.get(1);
              if (annotationIdArg == null) {
                throw new NullPointerException("annotationIdArg unexpectedly null.");
              }
              Result<Void> resultCallback = new Result<Void>() {
                public void success(Void result) {
                  wrapped.put("result", null);
                  reply.reply(wrapped);
                }
                public void error(Throwable error) {
                  wrapped.put("error", wrapError(error));
                  reply.reply(wrapped);
                }
              };

              api.resetSelection(managerIdArg, annotationIdArg, resultCallback);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon._ZnaidyAnnotationMessager.sendSticker", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String managerIdArg = (String)args.get(0);
              if (managerIdArg == null) {
                throw new NullPointerException("managerIdArg unexpectedly null.");
              }
              String annotationIdArg = (String)args.get(1);
              if (annotationIdArg == null) {
                throw new NullPointerException("annotationIdArg unexpectedly null.");
              }
              Result<Void> resultCallback = new Result<Void>() {
                public void success(Void result) {
                  wrapped.put("result", null);
                  reply.reply(wrapped);
                }
                public void error(Throwable error) {
                  wrapped.put("error", wrapError(error));
                  reply.reply(wrapped);
                }
              };

              api.sendSticker(managerIdArg, annotationIdArg, resultCallback);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon._ZnaidyAnnotationMessager.setUpdateRate", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String managerIdArg = (String)args.get(0);
              if (managerIdArg == null) {
                throw new NullPointerException("managerIdArg unexpectedly null.");
              }
              Number rateArg = (Number)args.get(1);
              if (rateArg == null) {
                throw new NullPointerException("rateArg unexpectedly null.");
              }
              Result<Void> resultCallback = new Result<Void>() {
                public void success(Void result) {
                  wrapped.put("result", null);
                  reply.reply(wrapped);
                }
                public void error(Throwable error) {
                  wrapped.put("error", wrapError(error));
                  reply.reply(wrapped);
                }
              };

              api.setUpdateRate(managerIdArg, (rateArg == null) ? null : rateArg.longValue(), resultCallback);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  private static Map<String, Object> wrapError(Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    return errorMap;
  }
}
