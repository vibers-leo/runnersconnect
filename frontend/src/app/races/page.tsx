import { races } from "@/lib/api";

interface Race {
  id: number;
  title: string;
  description: string;
  race_date: string;
  location: string;
  status: string;
  registration_start: string;
  registration_end: string;
}

export default async function RacesPage() {
  let raceList: Race[] = [];
  try {
    const data = await races.list();
    raceList = data.data || data;
  } catch {
    // API 연결 실패 시 빈 목록
  }

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <h1 className="text-3xl font-black text-gray-900 mb-2">대회 목록</h1>
      <p className="text-gray-500 mb-8">다가오는 러닝 대회를 확인하고 참가하세요</p>

      {raceList.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {raceList.map((race) => (
            <a
              key={race.id}
              href={`/races/${race.id}`}
              className="bg-white rounded-2xl border border-gray-200 overflow-hidden hover:shadow-lg transition"
            >
              <div className="h-40 bg-gradient-to-br from-indigo-100 to-purple-100 flex items-center justify-center">
                <span className="text-5xl">🏃</span>
              </div>
              <div className="p-5">
                <div className="flex items-center gap-2 mb-2">
                  <span className={`px-2 py-0.5 text-xs font-bold rounded-full ${
                    race.status === "open" ? "bg-green-100 text-green-700" :
                    race.status === "closed" ? "bg-gray-100 text-gray-500" :
                    "bg-indigo-100 text-indigo-700"
                  }`}>
                    {race.status === "open" ? "접수중" : race.status === "closed" ? "마감" : race.status}
                  </span>
                </div>
                <h3 className="text-lg font-bold text-gray-900 mb-1">{race.title}</h3>
                <p className="text-sm text-gray-500">{race.location}</p>
                {race.race_date && (
                  <p className="text-sm text-indigo-600 font-semibold mt-2">
                    {new Date(race.race_date).toLocaleDateString("ko-KR", {
                      year: "numeric", month: "long", day: "numeric"
                    })}
                  </p>
                )}
              </div>
            </a>
          ))}
        </div>
      ) : (
        <div className="text-center py-20 bg-white rounded-2xl border border-gray-200">
          <div className="text-5xl mb-4">🏃‍♂️</div>
          <h3 className="text-xl font-bold text-gray-900 mb-2">아직 등록된 대회가 없어요</h3>
          <p className="text-gray-500">곧 다양한 대회가 등록될 예정입니다!</p>
        </div>
      )}
    </div>
  );
}
