"use client";

import { useEffect, useMemo, useRef, useState } from "react";

type TCountDownProps = {
  user: string | undefined;
  releaseTTL?: string;
};

const CountDown: React.FC<TCountDownProps> = ({ user, releaseTTL = "60" }) => {
  const [current, setCurrent] = useState<number>(Date.now());
  const reloaded = useRef(false);

  const _releaseTTL = useMemo(() => {
    try {
      const tmp = parseInt(releaseTTL);
      if (isNaN(tmp)) throw new Error("Invalid TTL");
      return tmp;
    } catch (err) {
      return 60;
    }
  }, [releaseTTL]);

  const genDate = useMemo(() => {
    if (user === undefined) {
      return undefined;
    }

    const tmp = user.split("-");
    return parseInt(tmp[tmp.length - 1]);
  }, [user]);

  const duration = useMemo(() => {
    if (!genDate) return 0;
    return current / 1000 - genDate;
  }, [current, genDate]);

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrent(Date.now());
    }, 100);

    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    if (!reloaded.current && duration >= _releaseTTL) {
      reloaded.current = true;
      window.location.reload();
    }
  }, [duration, _releaseTTL]);

  if (!genDate) return null;

  return (
    <div>
      <h2>Cred generated {duration.toFixed(1)}s ago</h2>
    </div>
  );
};

export default CountDown;
