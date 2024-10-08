import CountDown from "@/components/CountDown";
import { getUsers } from "@/services/data";
import styles from "./page.module.css";

export default async function Home() {
  const users = await getUsers();

  const maskString = (str: string, visibleChars: number): string => {
    if (str.length <= visibleChars) {
      return str; // Return the string if it's shorter than the visible length
    }
    const visiblePart = str.substring(0, visibleChars);
    const maskedPart = '*'.repeat(16);
    return visiblePart + maskedPart;
  };


  return (
    <main className={styles.main}>
      <div className={styles.description}>
        <h1>PostgreSQL Connection Credential</h1>
        <CountDown
          user={process.env.PG_USER}
          releaseTTL={process.env.PG_RELEASE_TTL}
        />
        <div>
          <h2>
            Username:{" "}
            <span className={styles.username}>{maskString(process.env.PG_USER || "", 3)}</span>
          </h2>
          <h2>
            Password:{" "}
            <span className={styles.password}>{maskString(process.env.PG_PASSWORD || "", 3)}</span>
          </h2>
        </div>
        <h1>List user query result:</h1>
        <table className={styles.table}>
          <thead>
            <tr>
              <td>
                <span>User</span>
              </td>
              <td>
                <span>User&apos;s Attributes</span>
              </td>
            </tr>
          </thead>
          <tbody>
            {users.map(({ role_name, role_attributes }) => (
              <tr key={role_name}>
                <td>
                  <span>{maskString(role_name || "", 3)}</span>
                </td>
                <td>
                  <span>{role_attributes}</span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        <h1>Environments</h1>
        <table className={styles.table}>
          <thead>
            <tr>
              <td>
                <span>Key</span>
              </td>
              <td>
                <span>Value</span>
              </td>
            </tr>
          </thead>
          <tbody>
            {Object.entries(process.env).map(([key, value]) => (
              <tr key={key}>
                <td>
                  <span>{key}</span>
                </td>
                <td>
                  <span>{maskString(value || "", 3)}</span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </main>
  );
}

export const dynamic = "force-dynamic";
